class Chef
  module RepoKeys
    class BitbucketGithub
      def self.create_or_update(new_resource, node, modul, resource_name)
        accountname = node[:repo_keys][resource_name][:username]

        if new_resource.key
          public_key = new_resource.key
        else
          if new_resource.key_file
            file = ::File.open(new_resource.key_file, "r")
            public_key = file.read
          else
            Chef::Log.error "Neither key nor key_file are set, what do you expect me to do for #{ resource_name.to_s }::#{ accountname }/#{ new_resource.repo_slug }?"
          end
        end

        public_key = self.sanitize_public_key(public_key)

        api_provider = modul.new(:login => accountname, :password => node[:repo_keys][resource_name][:password])
        existing_keys = modul.repos.keys.list(accountname, new_resource.repo_slug)

        key_attributes = self.build_request_keys(:label => new_resource.label,
                                                 :key => public_key)

        if (existing_keys && current_key = existing_keys.detect { |key| key[:key] == public_key })
          if key_attributes.all? { |k, v| current_key[k] == v }
            Chef::Log.info "Key already exists for #{ resource_name.to_s }::#{ accountname }/#{ new_resource.repo_slug }, skipping"
          else
            Chef::Log.info "Updating key for #{ resource_name.to_s }::#{ accountname }/#{ new_resource.repo_slug }"
            api_provider.repos.keys.edit(accountname, new_resource.repo_slug, current_key[self.deploy_key_id_key], key_attributes)
          end
        else
          Chef::Log.info "Adding key for #{ resource_name.to_s }::#{ accountname }/#{ new_resource.repo_slug }"
          api_provider.repos.keys.create(accountname, new_resource.repo_slug, key_attributes)
        end
      end

      def self.sanitize_public_key(public_key)
        public_key
      end
    end

    class Bitbucket < BitbucketGithub
      DEPLOY_KEY_ID_KEY = :pk

      def self.create_or_update(new_resource, node)
        super(new_resource, node, ::BitBucket, :bitbucket)
      end

      def self.build_request_keys(options = {})
        { "label" => options[:label],
          "key" => options[:key] }
      end

      def self.deploy_key_id_key
        DEPLOY_KEY_ID_KEY
      end
    end

    class Github < BitbucketGithub
      DEPLOY_KEY_ID_KEY = :id

      def self.create_or_update(new_resource, node)
        super(new_resource, node, ::Github, :github)
      end

      def self.build_request_keys(options = {})
        { "title" => options[:label],
          "key" => options[:key] }
      end

      # Github automatically removes the comment part of the key - we'll do that too, for easier comparison
      def self.sanitize_public_key(public_key)
        public_key.split(" ")[0..-2].join(" ")
      end

      def self.deploy_key_id_key
        DEPLOY_KEY_ID_KEY
      end
    end
  end
end

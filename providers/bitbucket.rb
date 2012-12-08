action :create_or_update do
  accountname = node[:repo_keys][:bitbucket][:username]

  if new_resource.key
    public_key = new_resource.key
  else
    if new_resource.key_file
      file = ::File.open(new_resource.key_file, "r")
      public_key = file.read
    else
      Chef::Log.error "Neither key nor key_file are set, what do you expect me to do for #{ accountname }/#{ new_resource.repo_slug }?"
    end
  end

  bitbucket = BitBucket.new(:login => accountname, :password => node[:repo_keys][:bitbucket][:password])
  existing_keys = BitBucket.repos.keys.list(accountname, new_resource.repo_slug)

  key_attributes = { "label" => new_resource.label,
                     "key" => public_key }

  if (existing_keys && current_key = existing_keys.detect { |key| key[:key] == public_key })
    if key_attributes.all? { |k, v| current_key[k] == v }
      Chef::Log.info "Key already exists for #{ accountname }/#{ new_resource.repo_slug }, skipping"
    else
      Chef::Log.info "Updating key for #{ accountname }/#{ new_resource.repo_slug }"
      bitbucket.repos.keys.edit(accountname, new_resource.repo_slug, current_key[:pk], key_attributes)
    end
  else
    Chef::Log.info "Adding key for #{ accountname }/#{ new_resource.repo_slug }"
    bitbucket.repos.keys.create(accountname, new_resource.repo_slug, key_attributes)
  end
end

action :create_or_update do
  Chef::RepoKeys::Bitbucket.create_or_update(new_resource, node)
end

action :create_or_update do
  Chef::RepoKeys::Github.create_or_update(new_resource, node)
end

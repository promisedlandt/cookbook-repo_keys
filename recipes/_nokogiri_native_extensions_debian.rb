
execute "apt-get update" do
  ignore_failure true
  action :nothing
end.run_action(:run)

include_recipe "build-essential"

%w(libxslt-dev libxml2-dev).each do |pkg|
  package pkg do
    action :nothing
  end.run_action(:install)
end

#
# Cookbook Name:: repo_keys
# Recipe:: _bitbucket_debian
#
# Copyright (C) 2012 Nils Landt
#
# All rights reserved - Do Not Redistribute
#

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

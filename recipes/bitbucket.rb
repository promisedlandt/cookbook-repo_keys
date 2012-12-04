#
# Cookbook Name:: repo_keys
# Recipe:: bitbucket
#
# Copyright (C) 2012 Nils Landt
#
# All rights reserved - Do Not Redistribute
#

begin
  require "bitbucket_rest_api"
rescue LoadError
  include_recipe "repo_keys::_bitbucket_debian"

  chef_gem "bitbucket_rest_api"
  require "bitbucket_rest_api"
end

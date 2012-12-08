#
# Cookbook Name:: repo_keys
# Recipe:: github
#
# Copyright (C) 2012 Nils Landt
#
# All rights reserved - Do Not Redistribute
#

begin
  require "github_api"
rescue LoadError
  include_recipe "repo_keys::_github_debian"

  chef_gem "github_api"
  require "github_api"
end

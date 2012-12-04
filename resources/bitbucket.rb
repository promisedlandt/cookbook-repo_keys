actions :create_or_update

default_action :create_or_update

attribute :repo_slug, :kind_of => String, :name_attribute => true
attribute :key, :kind_of => String
attribute :key_file, :kind_of => String
attribute :label, :kind_of => String, :default => ""

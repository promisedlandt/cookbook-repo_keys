# repo_keys

Manage your Bitbucket deploy ssh keys via Chef.

# Shoulders of giants

This uses the [bitbucket_rest_api](https://github.com/vongrippen/bitbucket) gem.

# Requirements

* Chef 10

# Platforms

Only tested on Debian. Ubuntu might work. Everything else won't, until you can get bitbucket_rest_api to install, which shouldn't be hard.

# Performance

This will create an API call for every resource on every chef run. This is kinda slow.

# Recipes

## repo_keys::bitbucket

Installs the gem and it's needed packages.

# Attributes

## Default

## Bitbucket

To set deploy keys, you need admin access to the repository.

Currently, this cookbook only supports simple authentication.  

* `node[:repo_keys][:bitbucket][:username]` 
* `node[:repo_keys][:bitbucket][:password]`

If you need OAuth, let me know and I'll add it.

# Resources / Providers

## repo_keys_bitbucket

### Actions

Action | Description | Default
------ | ----------- | -------
create_or_update | creates the key or updates the label (if changed) | yes

### Attributes

Attribute | Description | Type | Default
--------- | ----------- | ---- | -------
repo_slug | Name of the repository to set key for | String | name
key String | SSH public key to set | String | 
key_file | Path to local file to read the SSH key from | String
label | Name of the key, will be shown in the web UI | String | ""

### Examples

#### Setting a key

    repo_keys_bitbucket "my_secret_gem" do
      key "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGGNhyiGmd63pcjRwqZgVNQ6mQ3Ydjv+KHquxmULafNt4d4ISfin7WAus7yrAxMRAGR98Rs9qoEReyt2heXAO/52MKHUdcxhKh3ENawq2IK0TCXienVruogkUKkqmDgRrXWJwBaB5VPmhpxY45M6kStk+peOMcscaXiavvpXM8QuKLPttfrv8TtRxOC44H7yH8kkAFNGTjbzvlqSbJlmxd4A2lqXwLHYpQcZ6+F3g6MsEyN5cE8Hd46bdPmV8OAoxr7jCoAZFvfGKxQbk4mRolVmPhdfuiq2mGAdWBdB6yJPqtf1RjY5Bzj+3u12OLgalBBYS+dT1dyMBXyglZhFPa vagrant@repo-keys-berkshelf"
      label "repo_keys_demonstration"
    end


    repo_keys_bitbucket "my_secret_gem" do
      key_file "/home/deployer/.ssh/id_rsa.pub"
      label "repo_keys_demonstration_from file"
    end


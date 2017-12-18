#
# Cookbook:: mycookbook
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

node['demo_base']['packages'].each do |p|
  package p
end

package "ntp"

service "ntpd" do
  action :start
end

users_manage 'sysadmin' do
  group_id 2300
  action [:create]
end

include_recipe "sudo"

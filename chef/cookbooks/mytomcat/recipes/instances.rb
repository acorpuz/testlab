#
# Cookbook:: mytomcat
# Recipe:: instances
#
# Copyright:: 2017, The Authors, All Rights Reserved.

node['mytomcat']['instances'].each do |inst|
  tomcat_install inst do
    version '7.0.81'
  end
end

node['mytomcat']['instances'].each do |inst|
  tomcat_service inst do
    action :start
  end
end

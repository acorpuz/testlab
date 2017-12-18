#
# Cookbook Name:: mytomcat
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

tomcat_install 'demoapp' do
  version '8.0.32'
end

tomcat_service 'demoapp' do
  action :start
end

service "tomcat_demoapp" do
  action [:enable,:start]
end

cookbook_file "/opt/tomcat_demoapp/webapps/foo.war" do
  source "foo.war"
  owner "tomcat_demoapp"
  mode "0775"
end

cookbook_file "/opt/tomcat_demoapp/conf/tomcat-users.xml" do
  source "tomcat-users.xml"
  owner "tomcat_demoapp"
  mode "0775"
  notifies :restart, 'service[tomcat_demoapp]', :delayed
end

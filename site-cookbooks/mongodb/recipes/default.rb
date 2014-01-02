#
# Cookbook Name:: mongodb
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
mongo_repo = "/etc/yum.repos.d/mongodb.repo" 
template mongo_repo do
  source "mongodb.repo.erb"
  owner "root"
  group "root"
  mode 0644
  not_if { File.exists?(mongo_repo) }
end

package "mongo-10gen" do
  action :install
end

package "mongo-10gen-server" do
  action :install
end

service "mongod" do
  supports :restart => true
  action [ :enable, :start ]
end

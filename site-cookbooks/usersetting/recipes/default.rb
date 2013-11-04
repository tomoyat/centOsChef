#
# Cookbook Name:: usersetting
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
data_ids = data_bag('users')
suders = []
data_ids.each do |id|
  u = data_bag_item('users',id)
  if u['sudoer'] == 'yes'
    suders << u['user_name']
  end
end

data_ids.each do |id|
  u = data_bag_item('users',id)
  group u['group_name'] do
    group_name u['group_name']
    gid u['gid']
    action [:create]
  end
  user u['user_name'] do
    uid u['uid']
    home u['home']
    password u['password']
    shell u['shell']
    supports :manage_home => true # make hoem directory
  end
  group u['group_name'] do
    group_name u['group_name']
    gid u['gid']
    members u['user_name']
    action [:modify]
  end
  directory "#{u['home']}/.ssh" do
    owner u['user_name']
    group u['user_name']
  end
  authorized_keys_file = "#{u['home']}/.ssh/authorized_keys"
  file authorized_keys_file do
    owner u['user_name']
    group u['user_name']
    mode 0600
    content "#{u['ssh_key']}"
    not_if { ::File.exists?("#{authorized_keys_file}") }
  end
  zshrc_file = "#{u['home']}/.zshrc"
  template zshrc_file do
    source "zshrc.erb"
    owner u['user_name']
    group u['user_name']
    mode 0644
    not_if { ::File.exists?(zshrc_file) }
  end
  screenrc_file = "#{u['home']}/.screenrc"
  template screenrc_file do
    source "screenrc.erb"
    owner u['user_name']
    group u['user_name']
    mode 0644
    not_if { ::File.exists?(screenrc_file) }
  end
end

group 'wheel' do
  members suders
  action [:modify]
end

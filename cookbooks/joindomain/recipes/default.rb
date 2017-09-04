#
# Cookbook:: joindomain
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.
joinad 'join' do
  domain '<domain name>'
  domain_user '<username>'
  domain_password data_bag_item('users','<username>')['password']
  ou '<OU PATH>'
end
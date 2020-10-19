#
# Cookbook:: my_first_cookbook
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

apt_package 'apache2' do
  action :install
end

file '/var/www/html/index.html' do
  content '<html>My Website!</html>'
end
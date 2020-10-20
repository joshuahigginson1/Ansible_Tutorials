#
# Cookbook:: lamp
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

apt_update 'all platforms' do
  frequency 86400
  action :periodic
end

include_recipe 'lamp::apache'
include_recipe 'lamp::dbsetup'
include_recipe 'lamp::app'
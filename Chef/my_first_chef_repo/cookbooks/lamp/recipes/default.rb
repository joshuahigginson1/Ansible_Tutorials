#
# Cookbook:: lamp
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

include_recipe 'lamp::apache'
include_recipe 'lamp::dbsetup'
include_recipe 'lamp::app'
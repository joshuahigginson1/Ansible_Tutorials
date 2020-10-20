#
# Cookbook:: my_first_cookbook
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

# Cross Distro Variable.

apache_package = value_for_platform_family(
  ['rhel', 'fedora', 'suse'] => 'httpd'
  'debian' => 'apache2'
)

# Install Apache.
package apache_package

# Add New File.
file '/var/www/html/index.html' do
  content '<html>My Website!</html>'
end

# Ensure that the apache service is started.
service apache do
  action [:enable, :start]
end
# Look in the attributes/default.rb file to see how the node attributes are set.

# Install Git
package 'git'

# Install PyTools
package 'python-setuptools'

# Installs our app from github.
git 'install_app' do
  repository node['app_repo_url']
  destination node['download_dir']
  action :sync  # Sync either clones OR checks out, then hard reset HEAD.
end

# Installs python 2.7 and pip are installed.
python_runtime '2' do
  provider :system
  options pip_version: true
  setuptools_version false
  wheel_version false
  virtualenv_version false
end

# Install our pip requirements.
pip_requirements node['download_dir'] + '/requirements.txt'

# Copies over our web app folder using rsync.
bash 'sync_app' do
  code <<-EOL
    rsync -r /tmp/appdir/ /var/www/webapp
  EOL
end

# Configure Apache using a Ruby erb Template.
apache2_default_site 'webapp' do
  template_source 'apache.conf.erb'
  action :enable
end

# Ensure that our files and dirs are set with correct permissions.

file '/var/www/webapp/wsgi.py' do
  mode '0755'
end

directory '/var/www/' do
  owner node['apache_settings']['user']
  group node['apache_settings']['user']
  recursive true
  mode '0755'
end
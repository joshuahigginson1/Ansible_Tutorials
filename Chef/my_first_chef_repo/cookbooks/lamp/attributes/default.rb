# This file sets the default attributes for our lamp cookbook.

# Apache Settings

default['apache_settings'] = value_for_platform_family(
  ['rhel', 'fedora', 'suse'] => {'service' => 'httpd', 'user' => 'apache'},
  'debian' => {'service' => 'apache2', 'user' => 'www-data' }
)

# Application Settings

default['app_repo_url'] = 'https://github.com/cloudacademy/flask-app'
default['download_dir'] = '/tmp/appdir'

# Database Settings

default['db_conn'] = {
  'host' => '127.0.0.1',
  'root' => 'root',
  'password' => 'databasePassword1'
}
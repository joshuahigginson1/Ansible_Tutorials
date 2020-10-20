# A recipe to install the MySQL client and server.

# Client Configuration.

mysql_client 'default' do
  action :create
end

password = 'NOTTHEPASSWORD'

# Make sure that the MySQL service exists, and is running.
# Cross Platform Compatibility using platform_family method.

mysql_service 'default' do
  bind_address '127.0.0.1'
  port '3306'
  data_dir '/data'
  initial_root_password password
  socket '/var/run/mysqld/mysqld.sock' if platform_family?('debian')
  socket '/var/lib/mysql/mysql.sock' if platform_family?('rhel', 'fedora', 'suse')
  action [:create, :start]
end

mysql2_chef_gem 'default' do
  action :install
end

# Create a hash for use in database creation.

conn = {
  :host => '127.0.0.1',
  :username => 'root',
  :password => password
}

# Create the database instance.

Chef::Provider::Database::Mysql 'appdata' do
  connection conn
  action :create
end

Chef::Provider::Database::MysqlUser 'appuser' do
  connection conn
  password password

  # By default, the :grant symbol applies full permissions to a user.

  action [:create, :grant]
end
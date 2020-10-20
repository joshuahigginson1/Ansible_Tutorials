# A recipe to install the MySQL client and server.

# Client Configuration.

mysql_client 'default' do
  action :create
end

# Make sure that the MySQL service exists, and is running.
# Cross Platform Compatibility using platform_family method.

mysql_service 'default' do
  bind_address '127.0.0.1'
  port '3306'
  data_dir '/data'
  initial_root_password node['db_conn']['password']
  socket '/var/run/mysqld/mysqld.sock' if platform_family?('debian')
  socket '/var/lib/mysql/mysql.sock' if platform_family?('rhel', 'fedora', 'suse')
  action [:create, :start]
end

# Create the database instance.

bash 'extract_module' do
  code <<-EOH
    gem update --system
    mysql -u #{node['db_conn']['root']} -p#{node['db_conn']['password']};
    CREATE DATABASE 'appdata';
  EOH
end

# Create an 'appuser' user, and grant them full permissions.

bash 'extract_module' do
  code <<-EOH
    mysql -u #{node['db_conn']['root']} -p#{node['db_conn']['password']};
    CREATE USER 'appuser'@'#{node['db_conn']['host']}' IDENTIFIED BY '#{node['db_conn']['password']}';
    GRANT ALL PRIVILEGES ON * . * TO 'appuser'@'#{node['db_conn']['host']}';
  EOH
end

# service['apache2'] is defined in the apache2_default_install resource but other resources are currently unable to reference it.  To work around this issue, define the following helper in your cookbook:

apache2_install 'default_install'

service 'apache2' do
  supports restart: true, status: true, reload: true
  action :enable
end

apache2_mod_wsgi 'default_install' do
  install_package true
  action :create
end
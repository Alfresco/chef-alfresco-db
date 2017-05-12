# Chef::Recipe.send(:include, MysqlCookbook::Helpers)
# Chef::Recipe.send(:include, AlfrescoHelper2)
# Chef::Resource::RubyBlock.send(:include, AlfrescoHelper2)

db_database = node['db']['name']
db_host = node['db']['host']
db_port = node['db']['port']
db_user = node['db']['username']
db_pass = node['db']['password']

db_root_user = node['db']['root_user']
db_allowed_host = node['db']['allowed_host']
mysql_root_password = node['db']['server_root_password']

mysql_version = node['mysql_local']['version']
bind_address = node['mysql_local']['bind_address']
service_name = node['mysql_local']['service_name']

# Enforce mode and ownership of /tmp folder
directory '/tmp' do
  owner 'root'
  group 'root'
  mode 00777
end

mysql2_chef_gem 'default' do
  client_version mysql_version
  action :install
end

{ 'mysqld_db_t' => "/var/lib/mysql-#{service_name}",
  'mysqld_log_t' => "/var/log/mysql-#{service_name}" }.each do |sc, f|
  directory f do
    recursive true
    action :create
    only_if { enforcing? }
    only_if { semanage_installed? }
  end
  selinux_policy_fcontext "#{f}(/.*)?" do
    secontext sc
    only_if { enforcing? }
    only_if { semanage_installed? }
  end
end

user 'mysql'

log_bin = node['mysql_local']['my_cnf']['mysqld']['log-bin']
if log_bin && !log_bin.to_s.empty?
  log_bin_dirname = File.dirname(log_bin)
  if log_bin.start_with?('/')
    log_bin_folder = log_bin_dirname
  elsif log_bin_dirname != '.'
    log_bin_folder = "#{node['mysql_local']['datadir']}/#{log_bin_dirname}"
  end
  log "log_bin_folder: #{log_bin_folder}"
end

directory 'log_bin_folder' do
  path log_bin_folder
  owner 'mysql'
  group 'mysql'
  mode 00700
  recursive true
  action :create
  not_if { log_bin_folder.to_s.empty? }
end

mysql_service service_name do
  port db_port
  version mysql_version
  initial_root_password mysql_root_password
  bind_address bind_address
  data_dir node['mysql_local']['datadir']
  action [:create, :redeploy_mycfn_template, :start]
end

directory node['mysql_local']['datadir'] do
  mode 00700
  action :create
end

mysql_connection_info =
  {
    host: db_host,
    username: db_root_user,
    password: mysql_root_password,
  }

mysql_database db_database do
  connection mysql_connection_info
  collation node['mysql_local']['collation']
  encoding node['mysql_local']['encoding']
  action :create
end

mysql_database_user db_user do
  connection mysql_connection_info
  host db_allowed_host
  password db_pass
  action [:create, :grant]
end

user 'mysql' do
  shell '/sbin/nologin'
  action :modify
end

file '/root/.mysql_history' do
  action :delete
end

link '/root/.mysql_history' do
  to '/dev/null'
  link_type :symbolic
end

directory '/usr/lib64/mysql/plugin/' do
  mode 00775
  action :create
  owner 'mysql'
  group 'mysql'
end

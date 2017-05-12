require 'spec_helper'

RSpec.describe 'alfresco-db::mysql_local' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(
      platform: 'centos',
      version: '7.2.1511',
      file_cache_path: '/var/chef/cache'
    ) do |node|
    end.converge(described_recipe)
  end

  before do
  end

  let(:shellout_0) { double(exitstatus: 0) }
  let(:shellout_1) { double(exitstatus: 1) }

  it 'should create a tmp directory' do
    expect(chef_run).to create_directory('/tmp').with(
      owner:   'root',
      group:  'root',
      mode: 00777
    )
  end

  it 'should install mysql2_chef_gem' do
    expect(chef_run).to install_mysql2_chef_gem('default').with(
      client_version:   '5.6'
    )
  end

  it 'should create a /var/lib/mysql-default directory' do
    allow(Chef::Mixin::ShellOut).to receive(:shell_out).with('getenforce | grep -i enforcing').and_return(shellout_0)
    allow(Chef::Mixin::ShellOut).to receive(:shell_out).with('which semanage').and_return(shellout_0)
    expect(chef_run).to create_directory('/var/lib/mysql-default')
  end

  it 'should create a /var/log/mysql-default directory' do
    allow(Chef::Mixin::ShellOut).to receive(:shell_out).with('getenforce | grep -i enforcing').and_return(shellout_0)
    allow(Chef::Mixin::ShellOut).to receive(:shell_out).with('which semanage').and_return(shellout_0)
    expect(chef_run).to create_directory('/var/log/mysql-default')
  end

  it 'should run selinux_policy_fcontext on /var/lib/mysql-default' do
    allow(Chef::Mixin::ShellOut).to receive(:shell_out).with('getenforce | grep -i enforcing').and_return(shellout_0)
    allow(Chef::Mixin::ShellOut).to receive(:shell_out).with('which semanage').and_return(shellout_0)
    expect(chef_run).to addormodify_selinux_policy_fcontext('/var/lib/mysql-default(/.*)?').with(
      secontext: 'mysqld_db_t'
    )
  end

  it 'should not run selinux_policy_fcontext on /var/lib/mysql-default if selinux not enforcing' do
    allow(Chef::Mixin::ShellOut).to receive(:shell_out).with('getenforce | grep -i enforcing').and_return(shellout_1)
    allow(Chef::Mixin::ShellOut).to receive(:shell_out).with('which semanage').and_return(shellout_0)
    expect(chef_run).not_to addormodify_selinux_policy_fcontext('/var/lib/mysql-default(/.*)?').with(
      secontext: 'mysqld_db_t'
    )
  end

  it 'should run selinux_policy_fcontext on /var/log/mysql-default' do
    allow(Chef::Mixin::ShellOut).to receive(:shell_out).with('getenforce | grep -i enforcing').and_return(shellout_0)
    allow(Chef::Mixin::ShellOut).to receive(:shell_out).with('which semanage').and_return(shellout_0)
    expect(chef_run).to addormodify_selinux_policy_fcontext('/var/log/mysql-default(/.*)?').with(
      secontext: 'mysqld_log_t'
    )
  end

  it 'should not run selinux_policy_fcontext on /var/log/mysql-default if selinux not enforcing' do
    allow(Chef::Mixin::ShellOut).to receive(:shell_out).with('getenforce | grep -i enforcing').and_return(shellout_0)
    allow(Chef::Mixin::ShellOut).to receive(:shell_out).with('which semanage').and_return(shellout_1)
    expect(chef_run).not_to addormodify_selinux_policy_fcontext('/var/log/mysql-default(/.*)?').with(
      secontext: 'mysqld_log_t'
    )
  end

  it 'should create a mysql user' do
    expect(chef_run).to create_user('mysql').with(
      username: 'mysql'
    )
  end

  it 'should create a log_bin_folder directory' do
    chef_run.node.normal['mysql_local']['datadir'] = '/media/mysql-default'
    chef_run.node.normal['mysql_local']['my_cnf']['mysqld']['log-bin'] = 'log-bin/mysql-bin'
    chef_run.converge(described_recipe)
    expect(chef_run).to create_directory('log_bin_folder').with(
      path: '/media/mysql-default/log-bin',
      owner:   'mysql',
      group:  'mysql',
      mode: 00700
    )
  end

  it 'should create a log_bin_folder directory' do
    chef_run.node.normal['mysql_local']['datadir'] = '/media/mysql-default'
    chef_run.node.normal['mysql_local']['my_cnf']['mysqld']['log-bin'] = '/log-bin/mysql-bin'
    chef_run.converge(described_recipe)
    expect(chef_run).to create_directory('log_bin_folder').with(
      path: '/log-bin',
      owner:   'mysql',
      group:  'mysql',
      mode: 00700
    )
  end

  it 'should not create a log_bin_folder directory' do
    chef_run.node.normal['mysql_local']['datadir'] = '/media/mysql-default'
    chef_run.node.normal['mysql_local']['my_cnf']['mysqld']['log-bin'] = ''
    chef_run.converge(described_recipe)
    expect(chef_run).not_to create_directory('/log-bin')
  end

  it 'should not create a log_bin_folder directory' do
    chef_run.node.normal['mysql_local']['datadir'] = '/media/mysql-default'
    chef_run.node.normal['mysql_local']['my_cnf']['mysqld']['log-bin'] = nil
    chef_run.converge(described_recipe)
    expect(chef_run).not_to create_directory('/log-bin')
  end

  it 'should not create a log_bin_folder directory' do
    chef_run.node.normal['mysql_local']['datadir'] = '/media/mysql-default'
    chef_run.node.normal['mysql_local']['my_cnf']['mysqld']['log-bin'] = 'mysql-bin'
    chef_run.converge(described_recipe)
    expect(chef_run).not_to create_directory('/log-bin')
  end

  it 'should create a mysql service' do
    expect(chef_run).to create_mysql_service('default').with(
      port: '3306',
      version: '5.6',
      initial_root_password: 'alfresco',
      bind_address: nil,
      data_dir: '/media/mysql-default'
    )
  end

  it 'should start a mysql service' do
    expect(chef_run).to start_mysql_service('default').with(
      port: '3306',
      version: '5.6',
      initial_root_password: 'alfresco',
      bind_address: nil,
      data_dir: '/media/mysql-default'
    )
  end

  it 'should redeploy_mycfn_template a mysql service' do
    expect(chef_run).to redeploy_mycfn_template_mysql_service('default').with(
      port: '3306',
      version: '5.6',
      initial_root_password: 'alfresco',
      bind_address: nil,
      data_dir: '/media/mysql-default'
    )
  end

  it 'should not create a datadir directory' do
    expect(chef_run).to create_directory('/media/mysql-default').with(mode: 00700)
  end

  it 'should create a mysql_database' do
    mysql_connection_info =
      {
        host: '127.0.0.1',
        username: 'root',
        password: 'alfresco',
      }
    expect(chef_run).to create_mysql_database('alfresco').with(
      connection: mysql_connection_info,
      collation: 'utf8_general_ci',
      encoding: 'utf8'
    )
  end

  it 'should create a mysql_database_user' do
    mysql_connection_info =
      {
        host: '127.0.0.1',
        username: 'root',
        password: 'alfresco',
      }
    expect(chef_run).to create_mysql_database_user('alfresco').with(
      connection: mysql_connection_info,
      host: '127.0.0.1',
      password: 'alfresco'
    )
  end

  it 'should grant a mysql_database_user' do
    mysql_connection_info =
      {
        host: '127.0.0.1',
        username: 'root',
        password: 'alfresco',
      }
    expect(chef_run).to grant_mysql_database_user('alfresco').with(
      connection: mysql_connection_info,
      host: '127.0.0.1',
      password: 'alfresco'
    )
  end

  it 'should modify user mysql' do
    expect(chef_run).to modify_user('mysql').with(
      shell: '/sbin/nologin'
    )
  end

  it 'delete file /root/.mysql_history' do
    expect(chef_run).to delete_file('/root/.mysql_history')
  end

  it 'link /root/.mysql_history to /dev/null' do
    expect(chef_run).to create_link('/root/.mysql_history').with(
      to: '/dev/null',
      link_type: :symbolic
    )
  end

  it 'create directory /usr/lib64/mysql/plugin' do
    expect(chef_run).to create_directory('/usr/lib64/mysql/plugin/').with(
      mode: 00775,
      owner: 'mysql',
      group: 'mysql'
    )
  end
end

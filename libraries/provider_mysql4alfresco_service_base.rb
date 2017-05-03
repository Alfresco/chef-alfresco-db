require 'chef/provider/lwrp_base'

class Chef
  class Resource
    class MysqlService < Chef::Resource::LWRPBase
      actions :create, :delete, :start, :stop, :restart, :reload, :redeploy_mycfn_template
    end
  end
end

class Chef
  class Provider
    class MysqlServiceBase < Chef::Provider::LWRPBase
      use_inline_resources

      action :redeploy_mycfn_template do
        # using custom template for my.cnf
        template "#{new_resource.name} :create #{etc_dir}/my.cnf" do
          path "#{etc_dir}/my.cnf"
          source 'my.cnf.erb'
          cookbook node['mysql_local']['my_cnf']['cookbook']
          owner new_resource.run_user
          group new_resource.run_group
          mode '0600'
          variables(
            config: new_resource,
            error_log: error_log,
            include_dir: include_dir,
            lc_messages_dir: lc_messages_dir,
            pid_file: pid_file,
            socket_file: socket_file,
            tmp_dir: tmp_dir,
            data_dir: parsed_data_dir,
            mysqld: node['mysql_local']['my_cnf']['mysqld'],
            mysqld_safe: node['mysql_local']['my_cnf']['mysqld_safe'],
            mysql: node['mysql_local']['my_cnf']['mysql'],
            client: node['mysql_local']['my_cnf']['client']
          )
          action :create
        end
      end
    end
  end
end

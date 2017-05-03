default['mysql_local']['version'] = '5.6'
default['mysql_local']['bind_address'] = nil
default['mysql_local']['service_name'] = 'default'
default['mysql_local']['collation'] = 'utf8_general_ci'
default['mysql_local']['encoding'] = 'utf8'
default['mysql_local']['datadir'] = lazy { "/media/mysql-#{node['mysql_local']['service_name']}" }

default['mysql_local']['my_cnf']['mysqld']['local-infile'] = 0
default['mysql_local']['my_cnf']['mysqld']['skip-grant-tables'] = 'FALSE'
default['mysql_local']['my_cnf']['mysqld']['skip_symbolic_links'] = 'YES'
default['mysql_local']['my_cnf']['mysqld']['sql_mode'] = 'STRICT_ALL_TABLES'
default['mysql_local']['my_cnf']['mysqld']['log-bin'] = 'log-bin/mysql-bin'
default['mysql_local']['my_cnf']['mysqld']['slow_query_log'] = 1
default['mysql_local']['my_cnf']['mysqld']['slow_query_log_file'] = lazy { "/var/log/mysql-#{node['mysql_local']['service_name']}/slow.log" }
default['mysql_local']['my_cnf']['mysqld']['long_query_time'] = 30
default['mysql_local']['my_cnf']['mysqld']['log_queries_not_using_indexes'] = 1
default['mysql_local']['my_cnf']['mysqld']['log-warnings'] = 2
default['mysql_local']['my_cnf']['mysqld']['log-raw'] = 'OFF'
default['mysql_local']['my_cnf']['mysqld']['general_log_file'] = lazy { "/var/log/mysql-#{node['mysql_local']['service_name']}/query.log" }
default['mysql_local']['my_cnf']['mysqld']['general_log'] = 1
# default['mysql_local']['my_cnf']['mysqld']['sql_mode'] = 'NO_AUTO_CREATE_USER'

default['mysql_local']['my_cnf']['cookbook'] = 'alfresco-db'

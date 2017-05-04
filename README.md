# chef-alfresco-db cookbook
[![Build Status](https://travis-ci.org/Alfresco/chef-alfresco-db.svg)](https://travis-ci.org/Alfresco/chef-alfresco-db?branch=master)
[![Cookbook Version](http://img.shields.io/cookbook/v/alfresco-db.svg)](https://github.com/Alfresco/chef-alfresco-db)
[![Coverage Status](https://coveralls.io/repos/github/Alfresco/chef-alfresco-db/badge.svg?branch=master)](https://coveralls.io/github/Alfresco/chef-alfresco-db?branch=master)

This cookbook will install the DBMS part of the Alfresco stack.
The default choice is Mysql, but it can be expanded to use your own db.

## Requirements

### Cookbooks

The following cookbooks are direct dependencies because they're used for common "default" functionality.

- [`mysql`](https://github.com/chef-cookbooks/mysql) for MySql installation
- [`poise-derived`](https://github.com/poise/poise-derived) for defining lazily evaluated node attributes
- [`mysql2_chef_gem`](https://github.com/sinfomicien/mysql2_chef_gem) library cookbook that provides a resource for installing the mysql2 gem against either mysql or mariadb depending on usage
- [`selinux_policy`](https://github.com/sous-chefs/selinux_policy) to manage SELinux policies and components
- [`alfresco-utils`](https://github.com/Alfresco/chef-alfresco-utils) Chef utilities used by Chef-Alfresco

### Platforms

The following platforms are supported and tested with Test Kitchen:

- CentOS 7+

### Chef

- Chef 12.1+

## Attributes

| Key | Type | Description | Default |
|-----|------|-------------|---------|
| default['db']['name'] | String | DB name  | alfresco  |
| default['db']['host'] | String  |  DB host |  127.0.0.1 |
| default['db']['port'] | String   | DB port |  3306 |
| default['db']['username']  | String   | DB username |  alfresco |
| default['db']['password'] | String | DB password |  alfresco |
| default['db']['root_user'] | String  |  DB root user |  false |
| default['db']['allowed_host'] | String  | Allowed host | 127.0.0.1 |
| default['db']['server_root_password']  | String  | DB Root Password |  true |
| default['db']['engine']  | String  | Engine of choice |  mysql |

other specific MySql Attributes

| Key | Type | Description | Default |
|-----|------|-------------|---------|
| default['mysql_local']['version'] | String | Mysql Version | '5.6'
| default['mysql_local']['bind_address'] | String | [`bind_address`](https://dev.mysql.com/doc/refman/5.6/en/server-options.html#option_mysqld_bind-address) | nil
| default['mysql_local']['service_name'] | String | Mysql service name | default'
| default['mysql_local']['collation'] | String | [`collation`](https://dev.mysql.com/doc/refman/5.6/en/charset-applications.html) | utf8_general_ci
| default['mysql_local']['encoding'] | String | [`encoding`](https://dev.mysql.com/doc/refman/5.6/en/charset-applications.html) | utf8
| default['mysql_local']['datadir'] | String | [`datadir`](https://dev.mysql.com/doc/refman/5.6/en/server-options.html#option_mysqld_datadir) | /media/mysql-default/
| default['mysql_local']['my_cnf']['mysqld']['local-infile'] | Int | [`local-infile`](https://dev.mysql.com/doc/refman/5.6/en/mysql-command-options.html#option_mysql_local-infile) | 0
| default['mysql_local']['my_cnf']['mysqld']['skip-grant-tables'] | String | [`skip-grant-tables`](https://dev.mysql.com/doc/refman/5.6/en/server-options.html#option_mysqld_skip-grant-tables) |  FALSE
| default['mysql_local']['my_cnf']['mysqld']['skip_symbolic_links'] | String | [`skip_symbolic_links`](https://dev.mysql.com/doc/refman/5.6/en/server-options.html#option_mysqld_symbolic-links) | 'YES'
| default['mysql_local']['my_cnf']['mysqld']['sql_mode'] | String | [`sql_mode`](https://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html#sysvar_sql_mode) | 'STRICT_ALL_TABLES'
| default['mysql_local']['my_cnf']['mysqld']['log-bin'] | String | [`log-bin`](https://dev.mysql.com/doc/refman/5.6/en/replication-options-binary-log.html#option_mysqld_log-bin) | 'log-bin/mysql-bin'
| default['mysql_local']['my_cnf']['mysqld']['slow_query_log'] | Int | [`slow_query_log`](https://dev.mysql.com/doc/refman/5.6/en/slow-query-log.html)| 1
| default['mysql_local']['my_cnf']['mysqld']['slow_query_log_file'] | String |  [`slow_query_log_file`](https://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html#sysvar_slow_query_log_file) | /var/log/mysql-default/slow.log
| default['mysql_local']['my_cnf']['mysqld']['long_query_time'] | Int | [`long_query_time`](https://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html#sysvar_long_query_time) | 30
| default['mysql_local']['my_cnf']['mysqld']['log_queries_not_using_indexes'] | Int | [`log_queries_not_using_indexes`](https://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html#sysvar_log_queries_not_using_indexes) | 1
| default['mysql_local']['my_cnf']['mysqld']['log-warnings'] | Int | [`log-warnings`](https://dev.mysql.com/doc/refman/5.6/en/server-options.html#option_mysqld_log-warnings) | 2
| default['mysql_local']['my_cnf']['mysqld']['log-raw'] | String | [`log-raw`](https://dev.mysql.com/doc/refman/5.6/en/server-options.html#option_mysqld_log-raw) | 'OFF'
| default['mysql_local']['my_cnf']['mysqld']['general_log_file'] | String | [`general_log_file`](https://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html#sysvar_general_log_file) | /var/log/mysql-default/query.log
| default['mysql_local']['my_cnf']['mysqld']['general_log'] | Int | [`general_log`](https://dev.mysql.com/doc/refman/5.6/en/server-system-variables.html#sysvar_general_log) | 1
| default['mysql_local']['my_cnf']['cookbook'] | String | cookbook for [my.cnf.erb](./templates/default/my.cnf.erb) template | 'alfresco-db'


## Usage

Just add the reference of this cookbook inside your `metadata.rb` file:

```
depends 'alfresco-db', '~> v0.1'
```

Main recipe is:

- `alfresco-db::default` will install the Application Server of your choice ( specified under the `default['db']['engine']` attribute)

Include `alfresco-db` in your node `run_list`:

```json
{
  "run_list": [
    "recipe[alfresco-db:default]"
  ]
}
```
## Testing
Refer to: [Testing](./TESTING.md)
## License and Authors

- Author:: Marco Mancuso (<marco.mancuso@alfresco.com>)

```text
Copyright 2017, Alfresco

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
```

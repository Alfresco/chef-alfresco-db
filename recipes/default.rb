#
# Cookbook:: chef-alfresco-db
# Recipe:: default
#
# Copyright:: 2017, Alfresco Software Ltd, All Rights Reserved.

include_recipe "alfresco-db::#{node['db']['engine']}_local"

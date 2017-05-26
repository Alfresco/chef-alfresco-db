name 'alfresco-db'
maintainer 'Alfresco Tooling and Automation Team'
maintainer_email 'devops@alfresco.com'
license 'Apache 2.0'
description 'Installs/Configures chef-alfresco-db'
long_description 'Installs/Configures chef-alfresco-db'
version '1.3'

chef_version '~> 12' if respond_to?(:chef_version)

issues_url 'https://github.com/Alfresco/chef-alfresco-db/issues' if respond_to?(:issues_url)
source_url 'https://github.com/Alfresco/chef-alfresco-db' if respond_to?(:source_url)

supports 'centos', '>= 7.0'

depends 'mysql', '~> 7.2'
depends 'mysql2_chef_gem', '>= 1.0.1'
depends 'selinux_policy', '~> 2.0.1'
depends 'database', '>= 4.0.6'
depends 'alfresco-utils', '~> 1.2.0'
depends 'poise-derived', '~> 1.0.0'

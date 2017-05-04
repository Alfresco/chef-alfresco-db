# chef-alfresco-db TESTING doc

This document describes the process for testing chef-alfresco-db cookbook using ChefDK.

## Testing Prerequisites

A working ChefDK installation set as your system's default ruby. ChefDK can be downloaded at <https://downloads.chef.io/chef-dk/>

Either
Hashicorp's [Vagrant](https://www.vagrantup.com/downloads.html) and Oracle's [Virtualbox](https://www.virtualbox.org/wiki/Downloads) for integration testing or [Docker](https://docs.docker.com/engine/installation/)

## Installing dependencies

Cookbooks may require additional testing dependencies that do not ship with ChefDK directly. These can be installed into the ChefDK ruby environment with the following commands

Install dependencies:

```shell
chef exec bundle install
```

Update any installed dependencies to the latest versions:

```shell
chef exec bundle update
```

### lint stage

The lint stage runs Ruby specific code linting using cookstyle (<https://github.com/chef/cookstyle>). Cookstyle offers a tailored RuboCop configuration enabling / disabling rules to better meet the needs of cookbook authors. Cookstyle ensures that projects with multiple authors have consistent code styling.

Run cookstyle using

```shell
chef exec bundle exec cookstyle
```

### syntax stage

The syntax stage runs Chef cookbook specific linting and syntax checks with Foodcritic (<http://www.foodcritic.io/>). Foodcritic tests for over 60 different cookbook conditions and helps authors avoid bad patterns in their cookbooks.

Run foodcritic using:

```shell
chef exec bundle exec foodcritic -f any .
```

## unit stage

The unit stage runs unit testing with ChefSpec (<http://sethvargo.github.io/chefspec/>). ChefSpec is an extension of Rspec, specially formulated for testing Chef cookbooks. Chefspec compiles your cookbook code and converges the run in memory, without actually executing the changes. The user can write various assertions based on what they expect to have happened during the Chef run. Chefspec is very fast, and quick useful for testing complex logic as you can easily converge a cookbook many times in different ways.

```shell
chef exec bundle exec rspec
```

## Integration Testing

Integration testing is performed by Test Kitchen. After a successful converge, tests are uploaded and ran out of band of Chef. Tests should be designed to ensure that a recipe has accomplished its goal.

Integration tests can be performed on a local workstation using vagrant with VirtualBox as the virtualization hypervisor or Docker containers.
The general command to run the tests is


<pre>
chef exec bundle exec rake 'integration:<b>DRIVER</b>[<b>SUITE</b>,<b>KITCHEN_COMMAND</b>]'
</pre>

Where

- **DRIVER** can either be `vagrant` or `docker`,
- **SUITE** is one of the suites defined in .kitchen.yml (vagrant) or .kitchen.docker.yml (docker)
 - current suites available are:
   - default

   Use empty suite value to run all of them
- **KITCHEN_COMMAND** one of the Kitchen phase commands:  [Kitchen commands](https://github.com/test-kitchen/test-kitchen/wiki/Getting-Started)

Examples:

To run default suite with Vagrant using the Kitchen _test_ command
```shell
chef exec bundle exec rake 'integration:vagrant[default,test]'
```

To run default suite with Docker using the Kitchen _verify_ command

```shell
chef exec bundle exec rake 'integration:docker[default,verify]'
```

To run all the available suites with Vagrant using the Kitchen _converge_ command

```shell
chef exec bundle exec rake 'integration:vagrant[,converge]'
```

# Mediacommons VM

Mediacommons VM is a VM for Mediacommons's Drupal 7, built with Ansible. This project is based on [Drupal VM](https://github.com/geerlingguy/drupal-vm), for detail information please see [ Drupal VM's documentation](http://docs.drupalvm.com/en/latest/)

In order to use Mediacommons VM, you need [Vagrant](https://www.vagrantup.com), [Ansible](https://ansible.com) and [VirtualBox](https://www.virtualbox.org).

For installation information and download requirements, see:

 - https://www.virtualbox.org/wiki/Downloads
 - https://www.vagrantup.com/downloads.html
 - https://docs.ansible.com/ansible/2.3/intro_installation.html

To speed up the build process, install the plugins:

- [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) - Automatically installs the host's VirtualBox Guest Additions on the guest system.

```bash
$ vagrant plugin install vagrant-vbguest
```

 - [vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater) - This plugin adds an entry to your /etc/hosts file on the host system

```bash
$ vagrant plugin install vagrant-hostsupdater
```

Mediacommons VM will install the following on an Ubuntu 16.04 linux VM:

- Apache 2.4.x
- PHP 7.2.x
- MySQL 5.7.x
- Drush
- Apache Solr 5.5.5
- Ruby 2.3.1p112
- SQLite
- [Adminer](https://www.adminer.org/)
- [MailHog](MailHog)
- [Node.js v8.11.3 LTS](https://nodejs.org/en/)
- [Nightwatch.js](http://nightwatchjs.org/)

After provisioning the VM all Mediacommons related code will live inside `code` directory and all `MediaCommons projects (sites)` inside `builds` directory in the same folder that has the `Vagrantfile`.

# Mediacommons projects provided by Mediacommons VM

Each project has its own source-code repository:

with Ansible (based on Drupal VM)
- [MediaCommons Core](https://github.com/NYULibraries/mediacommons_core.git) - Drupal core files and 3rd party modules, themes and libraries
- [MediaCommons Umbrella](https://github.com/NYULibraries/mediacommons_umbrella.git) - MediaCommons Umbrella install profile
- [MediaCommons Project](https://github.com/NYULibraries/mediacommons_projects.git) - MediaCommons Projects insMediaCommons Projecttall profiles
- [MediaCommons Theme](https://github.com/NYULibraries/mediacommons_theme) - MediaCommons theMediaCommons Projectme
- [MediaCommons Admin](https://github.com/NYULibraries/mediacommons_admin.git) - Admin theme for MediaCommons
- [MediaCommons Modules](https://github.com/NYULibraries/mediacommons_modules.git) - MediaCommons project default modules and features 

## Example of MediaCommons VM directory structure after provisioned

```
.
|-- default.config.yml
|-- builds
|   |-- alt-ac
|   |-- fieldguide
|   |-- intransition
|   |-- imr
|   |-- mediacommons
|   |-- tne 
|-- source
|   |-- mediacommons_admin
|   |-- mediacommons_core
|   |-- mediacommons_modules
|   |-- mediacommons_projects
|   |-- mediacommons_theme
|   |-- mediacommons_umbrella
|-- data
|-- lib
|-- provisioning
|-- README.md
|-- scripts
|   |-- after_init.sh
|   |-- clean_cache.sh
|   |-- configure_alias.sh
|   |-- copy_database_dumps.sh
|   |-- copy_sites.sh
|   |-- import_database_dump.sh
|   |-- solr.sh
`-- Vagrantfile
```

NOTE: *`Source code is available in the host machine`. You have easy access to read and write using your preferred editor. There is `no need to SSH to MediaCommons VM` in order to modify source code.*

NOTE: *Repositories are link to each build for easy development. See:*

```
$ cd /vagrant/builds/mediacommons/drupal/sites/all/modules && ls -al | grep mediacommons
lrwxrwxrwx  1 501 dialout   34 Jun 12 14:35 mediacommons_modules -> /vagrant/source/mediacommons_modules
```

## Quick Start Guide

This Quick Start Guide will help you quickly build all MediaCommons projects on the VM using a post provision script.

### 1 - Install Vagrant and VirtualBox

Download and install [Vagrant](https://www.vagrantup.com/downloads.html), [VirtualBox](https://www.virtualbox.org/wiki/Downloads) and *[Install Ansible](http://docs.ansible.com/intro_installation.html) on your host machine, so Mediacommons VM can run the provisioning steps locally instead of inside the VM.*.

### 2 - Build the Virtual Machine and deploy the sites for first time

1. Download this project and put it wherever you want.

```bash
$ git clone https://github.com/NYULibraries/mediacommons-vm.git
```

Note: *This process it is involved and require user input. Script will fail with timeout error if user fail to interact in timely fashion. If timeout, you need to run this script again.*

2. Build the machine using Vagrant

```bash
$ cd mediacommons-vm && vagrant up
```

Note: *If there are any errors during the course of running `vagrant up`, and it drops you back to your command prompt, just run `vagrant provision` to continue building the VM from where you left off. If there are still errors after doing this a few times, post an issue to this project's issue queue on GitHub with the error.*

Note: *You need to make sure your firewall allows for "Automatically allow signed software to receive incoming connections" before you run this commands.*

If Vagrant provision the machine without errors you will see a message that reads:

```
Your Vagrant box is ready to use!
Visit the dashboard for an overview of your site: http://dashboard.mediacommos.local (or http://192.168.88.88)
You can SSH into your machine with `vagrant ssh`. 
```

Note: *If you don't see the success message `stop`, and post an issue to this project's issue queue on GitHub with the error.*

If you see that messages, we `successfully build the new machine` and `all the code related to MediaCommons is now available inside folder "source"`.

Note: *Sites are not ready to see yet.*

3. SSH into Mediacommons VM

```bash
$ vagrant ssh
```

Note: * In the Terminal in the same folder that has the Vagrantfile*

4. Once inside Mediacommons VM, run after_init.sh. This script will copy Drupal 7 databases and copy the sites default directory including files directory from MediaCommons development server.

```bash
$ cd /vagrant/scripts && ./after_init.sh -u your_username
```

Note: *your_user_name is the username you use to access `bastion` (please contact me for more information if needed)*

Note: *First install needs `full involvement`. `Actions and input required`. This process will take time and will ask your input multiple times. You need to `respond in timely fashion` or the process will timeout and the build will have multiple errors.*

### 3 - Access the VM and tools

To login to MediaCommons VM, open your Terminal and in the same folder that has the `Vagrantfile` type:

```bash
$ vagrant ssh
```

Once inside MediaCommons VM, MediaCommons VM provide a set of bash scripts to help with local development.

1. Synchronise MediaCommons VM (`site` directory including `files`) with development server.

```bash
$ /vagrant/scripts/copy_sites.sh -u [username]
```

NOTE: *This process it is `involved and require user input`. Script will fail with `timeout error if user fail to interact in timely fashion`.*

2. Copy database dumps from development server. The script copy over the most current version of database from development server.

```bash
$ /vagrant/scripts/copy_database_dumps.sh -u [username]
``` 

NOTE: *This process `require user input`.*

NOTE: *databases dump will be copy over inside directory `/vagrant/data/databases`. Database dumps are also available in the host machine inside the directory `data/databases` in the same folder that has the `Vagrantfile`.*

3. Import local database dumps (copies from development server located inside `/vagrant/data/databases`), clean sites cache and run cron jobs.

```bash
$ /vagrant/scripts/copy_database_dumps.sh
```

NOTE: *If you need to update the databases dump, run first `copy_database_dumps.sh` script to grab the latest copies in the development server..*

4. Clean all projects cache and run cron jobs.

```bash
$ /vagrant/scripts/clean_cache.sh
```

5. Mark content to be index and index content from all the sites in the project.

```bash
$ /vagrant/scripts/solr.sh
```

5. Revert all sites features. Useful to use onces a feture was updated/change.

```bash
$ /vagrant/scripts/features-revert.sh
```

## Updating MediaCommons VM

To update MediaCommons

1) Update [MediaCommons VM](https://github.com/NYULibraries/mediacommons-vm) using Git.

```bash
$ git pull 
```

2) Update the virtual machine using provisioners. You can do this by running `vagrant up --provision` in the same folder that has the `Vagrantfile` or `vagrant provision` if the machine is already up.

If the machine is not up:

```bash
$ vagrant up --provision
```

If the machine is up:

```bash
$ vagrant provision
```

NOTE: *We used provisioners in Vagrant to automatically install software alter configurations, and more on the machine as part of the vagrant up process.*

## Development workflow and contributing

If you are interested in fixing issues and contributing directly to the code base, please see the document [CONTRIBUTING.md](https://github.com/NYULibraries/mediacommons-vm/blob/master/CONTRIBUTING.md)


## Quick internal links

- [Mediacommons](http://mediacommons.local/)
- [Fieldguide](http://mediacommons.local/fieldguide)
- [#alt-academy: Alternative Academic Careers](http://mediacommons.local/alt-ac)
- [In Media Res](http://mediacommons.local/imr)
- [The New Everyday](http://mediacommons.local/tne)
- [MediaCommons VM dashboard](http://dashboard.mediacommons.local/)
- [Adminer](http://mediacommons.local:8025/)
- [MailHog](http://mediacommons.local:8025/)
- [Apache Solr](http://mediacommons.local:8983/solr/#/)

## Questions and others

1. How do I start up MediaCommons VM?

- Open your Terminal and in the same folder that has the `Vagrantfile` and type:

```bash
$ vagrant up
```

2. How do I check if MediaCommons VM is running?

- Open your Terminal and in the same folder that has the `Vagrantfile` and type:

```bash
$ vagrant status
```

You should see a message like:

```bash
Current machine states:

mediacommons              running (virtualbox)
```

Note: *If MediaCommons VM is not running see "How do I start up MediaCommons VM?"*

3. How do I log into the virtual machine?

- To log into the virtual machine, open your Terminal and in the same folder that has the `Vagrantfile` and type:

```bash
$ vagrant ssh
```

NOTE: *You can also get the machine's SSH connection details with `vagrant ssh-config`.*

4. How do I power off MediaCommons VM?

- Open your Terminal and in the same folder that has the `Vagrantfile` and type:

```bash
$ vagrant halt
```

5. I can't get the machine to start. "An action 'up' was attempted on the machine 'mediacommons',
but another process is already executing an action on the machine."

 - This is not error related to MediaCommons VM. The problem is with the host machine. You need to find the process pid and kill it.
 
```bash
$ ps aux | grep vagrant # (or `ps aux | grep ruby`)
$ kill -9 $PID
```

6. Should I assume my vagrant login is the same as as my login to my local machine? 

- No. To login to MediaCommons VM, open your Terminal and in the same folder that has the `Vagrantfile` type:

```bash
$ vagrant ssh
```

Note: *Make sure MediaCommons VM it's already up before you try to login*

NOTE: *You can also get the machine's SSH connection details with `vagrant ssh-config`.*

7. Things are not working, can I start all over again?

- Yes. Make sure you `destroy` the current MediaCommons VM. Open your Terminal and in the same folder that has the `Vagrantfile` type:

```bash
$ vagrant destroy
```

NOTE: *After you `destroy` the machine remove MediaCommons VM (do not leave anything behind), clone the project again and repeat the instruction from `Quick Start Guide` in this README.md file.*

8. It seems to me that my MC vagrant works smoothly until I try to connect to VPN and then
it completely gives up the ghost.
- This is a "known issue". You need to reset your network. Please read [Vagrant box not reachable after VPN connection](https://stackoverflow.com/questions/24281008/vagrant-box-not-reachable-after-vpn-connection)

## About the project

Based on [Jeff Geerling](https://www.jeffgeerling.com/) Drupal VM.
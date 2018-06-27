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
- PHP 5.6.x
- MySQL 5.7.x
- Drush
- Apache Solr
- Adminer (Web UI for MySQL)
- Selenium
- Ruby
- SQLite
- MailHog

After provisioning the VM all Mediacommons related code will live inside `code` directory and all `MediaCommons projects (sites)` inside `builds` directory in the same folder that has the `Vagrantfile`.

# Mediacommons projects provided by Mediacommons VM

Each project has its own source-code repository:

- [MediaCommons VM](https://github.com/NYULibraries/mediacommons-vm) a virtual machine built
with Ansible (based on Drupal VM)
- [MediaCommons Core](https://github.com/NYULibraries/mediacommons_core.git) - Drupal core files and 3rd party modules, themes and libraries
- [MediaCommons](https://github.com/NYULibraries/mediacommons.git) - MediaCommons build and migration scripts
- [MediaCommons Umbrella](https://github.com/NYULibraries/mediacommons_umbrella.git) - MediaCommons Umbrella install profile
- [https://github.com/NYULibraries/mediacommons_projects](https://github.com/NYULibraries/mediacommons_projects.git) - MediaCommons Projects install profiles
- [MediaCommons theme](https://github.com/NYULibraries/mediacommons_theme) - MediaCommons theme
- [MediaCommons admin](https://github.com/NYULibraries/mediacommons_admin.git) - Admin theme for MediaCommons

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
|-- code
|   |-- mediacommons
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
|   |-- init.sh
|   |-- solr.sh
`-- Vagrantfile
```

NOTE: *`Source code is available in the host machine`. You have easy access to read and write using your preferred editor. There is `no need to SSH to MediaCommons VM` in order to modify source code.*

NOTE: *Repositories are link to each build (site) for easy development. See:*

```
$ cd /vagrant/builds/mediacommons/sites/all/modules && ls -al | grep mediacommons
lrwxrwxrwx  1 501 dialout   34 Jun 12 14:35 mediacommons_modules -> /vagrant/code/mediacommons_modules
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

2. Build the machine using Vagrant

```bash
$ cd mediacommons-vm && vagrant up
```

Note: *If there are any errors during the course of running `vagrant up`, and it drops you back to your command prompt, just run `vagrant provision` to continue building the VM from where you left off. If there are still errors after doing this a few times, post an issue to this project's issue queue on GitHub with the error.*

Note: *You need to make sure your firewall allows for "Automatically allow signed software to receive incoming connections" before you run this commands.*

If Vagrant provision the machine without errors you will see a message that reads:

```bash
Your Vagrant box is ready to use!
Visit the dashboard for an overview of your site: http://dashboard.mediacommos.local (or http://192.168.88.88)
You can SSH into your machine with `vagrant ssh`. 
```

Note: *If you don't see the success message `stop`, and post an issue to this project's issue queue on GitHub with the error.*

If you see that messages, we `successfully build the new machine` and `all the code related to MediaCommons is now available inside folder "code"`.

Note: *Sites are not ready to see yet.*

3. SSH into Mediacommons VM

```bash
$ vagrant ssh
```

Note: * In the Terminal in the same folder that has the Vagrantfile*

4. Once inside Mediacommons VM, run after_init.sh. after_init.sh will copy over databases, sites files directory and other assets to complete the installation process.

```bash
$ cd /vagrant/scripts && ./after_init.sh -u your_username
```

Note: *your_user_name is the username you use to access `bastion` (please contact me for more information if needed)*

Note: *First install needs full involvement. Actions and input required. This process will take time and will ask your input multiple times. You need to respond in timely fashion or the process will timeout and the build will have multiple errors.*

### 3 - Access the VM and tools

To login to MediaCommons VM, open your Terminal and in the same folder that has the `Vagrantfile` type:

```bash
$ vagrant ssh
```

## Other Notes

  - To shut down the virtual machine, enter `vagrant halt` in the Terminal in the same folder that has the `Vagrantfile`. To destroy it completely (if you want to save a little disk space, or want to rebuild it from scratch with `vagrant up` again), type in `vagrant destroy`.
  - To log into the virtual machine, enter `vagrant ssh`. You can also get the machine's SSH connection details with `vagrant ssh-config`.
  - When you rebuild the VM (e.g. `vagrant destroy` and then another `vagrant up`), make sure you clear out the contents of the `drupal` folder on your host machine, or Drupal will return some errors when the VM is rebuilt (it won't reinstall Drupal cleanly).

## Development workflow

- [Building a Drupal site with Git](https://www.drupal.org/node/803746) as an example of future workflow for our Drupal 7 sites.
- Also for reference [Git documentation](https://www.drupal.org/documentation/git)

## Contributing

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

3. How do I power off MediaCommons VM?

- Open your Terminal and in the same folder that has the `Vagrantfile` and type:

```bash
$ vagrant halt
```

4. I can't get the machine to start. "An action 'up' was attempted on the machine 'mediacommons',
but another process is already executing an action on the machine."

 - This is not error related to MediaCommons VM. The problem is with the host machine. You need to find the process pid and kill it.
 
```bash
$ ps aux | grep vagrant # (or `ps aux | grep ruby`)
$ kill -9 $PID
```

4. Should I assume my vagrant login is the same as as my login to my local machine? 

- No. To login to MediaCommons VM, open your Terminal and in the same folder that has the `Vagrantfile` type:

```bash
$ vagrant ssh
```

Note: *Make sure MediaCommons VM it's already up before you try to login*

5. Things are not working, can I start all over again?

- Yes. Make sure you `destroy` the current MediaCommons VM. Open your Terminal and in the same folder that has the `Vagrantfile` type:

```bash
$ vagrant destroy
```

6. It seems to me that my MC vagrant works smoothly until I try to connect to VPN and then
it completely gives up the ghost.
- This is a "known issue". You need to reset your network. Please read [Vagrant box not reachable after VPN connection](https://stackoverflow.com/questions/24281008/vagrant-box-not-reachable-after-vpn-connection)

After you `destroy` the machine remove MediaCommons VM (do not leave anything behind), clone the project again and repeat the instruction from `Quick Start Guide` in this README.md file.

## About the project

Based on [Jeff Geerling](https://www.jeffgeerling.com/) Drupal VM.
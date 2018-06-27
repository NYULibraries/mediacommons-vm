
# MediaCommons

## Each project has its own source-code repository

- [MediaCommons VM](https://github.com/NYULibraries/mediacommons-vm) a virtual machine built
with Ansible (based on Drupal VM)
- [MediaCommons Core](https://github.com/NYULibraries/mediacommons_core.git) - Drupal core files and 3rd party modules, themes and libraries
- [MediaCommons](https://github.com/NYULibraries/mediacommons.git) - MediaCommons build and migration scripts
- [MediaCommons Umbrella](https://github.com/NYULibraries/mediacommons_umbrella.git) - MediaCommons Umbrella install profile
- [MediaCommons Projects](https://github.com/NYULibraries/mediacommons_projects.git) - MediaCommons Projects install profiles
- [MediaCommons theme](https://github.com/NYULibraries/mediacommons_theme) - MediaCommons theme
- [MediaCommons admin](https://github.com/NYULibraries/mediacommons_admin.git) - Admin theme for MediaCommons

## MediaCommons development server

Everyday at midnight all the MediaCommons projects in [development server](http://dev.mediacommons.org/) are build from source using development branch. This process will continue until launch. Once MediaCommons is in production mode, this strategy will change.

# Introduction

This document is intended to outline a basic process of using Git in the context of MediaCommons site building, testing and deployment process.

This documentation assumes that the project will be following a basic 4-tier development environment model: developers work on most code locally using MediaCommons VM, then push
that code up through Development, Staging and Production environments.

## Branching

Our Git flow is a simplifed [Git-Flow](http://nvie.com/posts/a-successful-git-branching-model/). Much like Git-Flow, we take advantage of a master branch, a development branch, and feature branches.

### The master branch

This branch remains readily deployable at all times. It has no end to it's lifespan and only heavily tested code (or no code at all) is allowed in this exclusive branch.

### The development branch

This branch is where all ongoing work is done. It runs parallel to master, and incorporates all bugfixes and features. When the head of the development branch is tested and meets our coding requirements (to be discussed later), it graduates and gets merged to master via pull request.

### Feature branches

Feature branches branch off of development and must be merged back into development. A feature branch adds end-user functionality to the application. When working on a feature branch, it is important to only make changes that are relevant to the feature you are currently working on. Thus the lifespan of the feature branch is limited to the development of that feature. As a convention, we prefix feature branch names with ```feature/```, e.g., ```feature/add-foo```.

### Chore branches

Chore branches branch off of development and must be merged back into development. A chore branch does not add end-user functionality, but is used for housekeeping tasks, e.g., updating a configuration file. When working on a chore branch, it is important to only make changes that are relevant to the chore you are currently working on. Thus the lifespan of the chore branch is limited to the completion of the chore. As a convention, we prefix chore branch names with ```chore/```, e.g., ```chore/update-database-config```.

# Contributing

Adhering to the following process is the best way to get your work included in the project:

1. Clone the project. If you are using MediaCommons VM, all repositories related to MediaCommons can be found in the same folder that has the Vagrantfile.

```
.
|-- code
|   |-- mediacommons
|   |-- mediacommons_admin
|   |-- mediacommons_core
|   |-- mediacommons_modules
|   |-- mediacommons_projects
|   |-- mediacommons_theme
|   |-- mediacommons_umbrella
`-- Vagrantfile
```

See [MediaCommons VM](https://github.com/NYULibraries/mediacommons-vm) for more information.

2. If you cloned a while ago, get the latest changes from upstream:

```
$ git checkout development
$ git pull origin development
```

3. Create a new branch (off the main project development branch) to contain your feature, chore, or fix:

```
$ git checkout -b [feature|chore]/branch-name
```

4. Commit your changes in logical chunks. Please adhere to these [git commit message guidelines](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html) or your code is unlikely to be merged into the main project.

5. Locally merge (or rebase) the upstream development branch into your topic branch:

```
$ git pull [--rebase] upstream development
```

6. Push your topic branch up to your fork:

## Pull requests

Pull requests should remain focused in scope and avoid containing unrelated commits.

... more to come

## Test

Looking into using [Nightwatch](https://github.com/nightwatchjs/nightwatch) - Automated testing framework powered by [Node.js](https://nodejs.org/en/) and using [W3C Webdriver](https://saucelabs.com/products/open-source-frameworks/selenium/w3c-webdriver-protocol) (formerly Selenium).
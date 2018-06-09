#!/bin/bash

function tell() {
  echo "file: ${0} | line: ${LINENO} | echo: ${1}"
}

function get_repos() {
  echo "Clone MediaCommons repos"
  git clone https://github.com/NYULibraries/mediacommons_core.git ${VAGRANT_DIR}/code/mediacommons_core
  git clone https://github.com/NYULibraries/mediacommons.git ${VAGRANT_DIR}/code/mediacommons
  git clone https://github.com/NYULibraries/mediacommons_modules.git ${VAGRANT_DIR}/code/mediacommons_modules
  git clone https://github.com/NYULibraries/mediacommons_umbrella.git ${VAGRANT_DIR}/code/mediacommons_umbrella
  git clone https://github.com/NYULibraries/mediacommons_projects.git ${VAGRANT_DIR}/code/mediacommons_projects
  git clone https://github.com/NYULibraries/mediacommons_theme.git ${VAGRANT_DIR}/code/mediacommons_theme
  git clone https://github.com/NYULibraries/mediacommons_admin.git ${VAGRANT_DIR}/code/mediacommons_admin
  echo "Change branch to development branch"
  git --git-dir=${VAGRANT_DIR}/code/mediacommons_modules/.git --work-tree=${VAGRANT_DIR}/code/mediacommons_modules checkout develop
  git --git-dir=${VAGRANT_DIR}/code/mediacommons_theme/.git --work-tree=${VAGRANT_DIR}/code/mediacommons_theme checkout develop
  git --git-dir=${VAGRANT_DIR}/code/mediacommons_projects/.git --work-tree=${VAGRANT_DIR}/code/mediacommons_projects checkout develop
  git --git-dir=${VAGRANT_DIR}/code/mediacommons_umbrella/.git --work-tree=${VAGRANT_DIR}/code/mediacommons_umbrella checkout develop
}

function link_repos() {
  echo "Link repos"
  ln -s ${VAGRANT_DIR}/code/mediacommons_umbrella ${VAGRANT_DIR}/code/mediacommons_core/drupal/profiles/mediacommons_umbrella
  ln -s ${VAGRANT_DIR}/code/mediacommons_projects ${VAGRANT_DIR}/code/mediacommons_core/drupal/profiles/mediacommons_projects  
  ln -s ${VAGRANT_DIR}/code/mediacommons_modules ${VAGRANT_DIR}/code/mediacommons_core/drupal/sites/all/modules/mediacommons_modules
  ln -s ${VAGRANT_DIR}/code/mediacommons_admin ${VAGRANT_DIR}/code/mediacommons_core/drupal/sites/all/themes/mediacommons_admin
  ln -s ${VAGRANT_DIR}/code/mediacommons_theme ${VAGRANT_DIR}/code/mediacommons_core/drupal/sites/all/themes/mediacommons
}

# Copy sites
function copy_sites() {
  echo "Configure sites"
  for site in ${ALL_SITES[*]}
    do
      cp -r ${VAGRANT_DIR}/code/mediacommons_core/drupal ${VAGRANT_DIR}/builds/${site}
      mv ${VAGRANT_DIR}/builds/${site}/.htaccess.off ${VAGRANT_DIR}/builds/${site}/.htaccess
  done
}

function create_mycnf() {
  echo "Create MySQL .my.cnf"
  # add .my.cnf to the Vagrant box.
  cat << EOF > /home/vagrant/.my.cnf 
[client]
user=root
password=root
EOF
}

function configure_solr() {
  echo "Configure Solr 5.x"
  SOLR_CORE_NAME=mediacommons
  SOLR_VERSION=solr-5.x
  SOLR_CORE_PATH="/var/solr/data/$SOLR_CORE_NAME"
  # Copy new Solr collection core with the Solr configuration provided by module.
  sudo su - solr -c "/opt/solr/bin/solr create -c $SOLR_CORE_NAME -d ${VAGRANT_DIR}/code/mediacommons_core/drupal/sites/all/modules/apachesolr/solr-conf/$SOLR_VERSION/"
  # Adjust the autoCommit time so index changes are committed in 1s.
  sudo sed -i 's/\(<maxTime>\)\([^<]*\)\(<[^>]*\)/\11000\3/g' $SOLR_CORE_PATH/conf/solrconfig.xml
  # Restart Apache Solr.
  sudo service solr restart
}

VAGRANT_DIR=/vagrant

SETUP_COMPLETE_FILE=${VAGRANT_DIR}/scripts/init.out

# Mediacommons main site and channel sites
ALL_SITES=( mediacommons alt-ac fieldguide imr intransition tne )

if [ ! -e "$SETUP_COMPLETE_FILE" ]; then

  # Code directory
  mkdir -p ${VAGRANT_DIR}/code ${VAGRANT_DIR}/data/databases ${VAGRANT_DIR}/builds

  get_repos

  link_repos

  copy_sites

  create_mycnf

  configure_solr

  sudo apachectl restart

  echo `date +"%m-%d-%Y at %r"` >> ${SETUP_COMPLETE_FILE}  

else
  exit 0
fi

#!/bin/bash

function configure_alias() {
  echo "alias drush=/vagrant/code/mediacommons/bin/drush" >> ~/.bash_aliases
  echo "alias copy_database_dumps=/vagrant/scripts/copy_database_dumps.sh" >> ~/.bash_aliases
  echo "alias copy_sites=/vagrant/scripts/copy_sites.sh" >> ~/.bash_aliases
  echo "alias clean_cache=/vagrant/scripts/clean_cache.sh" >> ~/.bash_aliases  
  echo "alias solr=/vagrant/scripts/solr.sh" >> ~/.bash_aliases  
  echo "alias import_database_dump=/vagrant/scripts/import_database_dump.sh" >> ~/.bash_aliases
}

SETUP_COMPLETE_FILE=/vagrant/scripts/configure_alias.out

if [ ! -e "$SETUP_COMPLETE_FILE" ]; then

  touch ~/.bash_aliases

  configure_alias

  echo `date +"%m-%d-%Y at %r"` >> ${SETUP_COMPLETE_FILE}  

else
  exit 0
fi

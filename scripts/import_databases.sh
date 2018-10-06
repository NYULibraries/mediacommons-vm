#!/bin/bash

# Defined in ~/.bashrc, but can be overwritten
# PROJECT=mediacommons

# Defined in ~/.bashrc, but can be overwritten
# APP_DIR=/vagrant

# Defined in ~/.bashrc, but can be overwritten
# BUILD_PATH=/var/www/sites/mediacommons/builds

function import_databases() {
  for site in ${SITES[*]}
    do
      local database=$( echo $site | sed 's/-//' )
      if [ ! -d "$DATABASE_PATH/$site.sql" ]; then
        echo "Import $DATABASE_PATH/$site.sql"
        mysql -e "DROP DATABASE IF EXISTS ${database};"
        mysql -e "CREATE DATABASE ${database} CHARACTER SET utf8 COLLATE utf8_general_ci"
        mysql ${database} < $DATABASE_PATH/$site.sql
        if [ $? -eq 0 ]; then
          echo "Success importing database $DATABASE_PATH/$site.sql" 
          ${DRUSH} -y variable-set page_compression 0 --root=${BUILD_PATH}/${site}/drupal
          ${DRUSH} -y variable-set cache 0 --root=${BUILD_PATH}/${site}/drupal
          ${DRUSH} -y variable-set block_cache 0 --root=${BUILD_PATH}/${site}/drupal
          ${DRUSH} -y variable-set preprocess_css 0 --root=${BUILD_PATH}/${site}/drupal
          ${DRUSH} -y variable-set preprocess_js 0 --root=${BUILD_PATH}/${site}/drupal
          ${DRUSH} -y cc all --root=${BUILD_PATH}/${site}/drupal
          ${DRUSH} -y cron --root=${BUILD_PATH}/${site}/drupal
        else
          echo "Fail"
        fi
      fi
  done
}

function help() {
   echo " "
   echo " Usage: ${0}"
   echo " "
   echo " Options:"   
   echo "   -d      User to use for secure network connection"
   echo "   -s      Just import one site (mediacommons|alt-ac|fieldguide|imr|intransition|tne)"
   echo "   -h      Show brief help"
   echo " "
   exit 0
}

# Mediacommons main site and channel sites
SITES=( mediacommons alt-ac fieldguide imr intransition tne )

DATABASE_PATH=${APP_DIR}/data/databases

while getopts ":d:s:h" opt; do
 case $opt in
  d)
    DATABASE_PATH=$OPTARG
    ;;
  s)
    SITES=( $OPTARG )
    ;;
  h)
    help
    ;;
  esac
done

[ -d "$DATABASE_PATH" ] || die ${LINENO} "critical error" "Can't read databases path."

[ -f "$HOME/.my.cnf" ] || die ${LINENO} "critical error" "Unable to read $HOME/.my.cnf"

import_databases

exit 0

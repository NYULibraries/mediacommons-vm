#!/bin/bash

# I need to check the hostname and prevent the user from running the scipt if the user
# is trying to run the script in a host other that madiacommons.local.

die () {
  echo "file: ${0} | line: ${1} | step: ${2} | message: ${3}"
  exit 1
}

function copy_drupal_6_database() {
  echo "Copy database dumps"
  # Clear out old dumps.  If this is not done and the rsync fails for some reason,
  # the sites will be rebuilt with old databases, and this may or may not be
  # immediately apparent.
  if [ -z "$(ls -A ${DATABASE_DUMPS})" ]; then
      echo "Nothing to remove."
    else
     rm $DATABASE_DUMPS/*.sql
  fi  
  # To keep things simple, copy all the database dumps.
  rsync -azvh -e "ssh -o ProxyCommand='ssh -W %h:%p ${NETWORK_HOST_USERNAME}@${BASTION_HOST}'" ${NETWORK_HOST_USERNAME}@${DEV_SERVER}:${DEV_SERVER_DATABASE_DUMPS}/ $DATABASE_DUMPS/
}

function help() {
   echo " "
   echo " Usage: ./copy_drupal_6_database.sh -u username"
   echo " "
   echo " Options:"   
   echo "   -u      User to use for secure network connection"
   echo "   -h      Show brief help"
   echo " "
   exit 0
}

while getopts ":u:h" opt; do
 case $opt in
  u)
    NETWORK_HOST_USERNAME=$OPTARG
    ;;
  h)
    help
    ;;
  esac
done

[ $NETWORK_HOST_USERNAME ] || die ${LINENO} "critical error" "No network user provided. E.g., -u username"

# Bastion server
BASTION_HOST=b.dlib.nyu.edu

# Development server
DEV_SERVER=devmc2.dlib.nyu.edu

# Directory in development server with copies of Drupal 6 dumps
DEV_SERVER_DATABASE_DUMPS=/www/sites/mediacommons/lib/dbs

# Directory where storing local copies of devmc database dumps
DATABASE_DUMPS=/vagrant/data/databases/d6

mkdir -p ${DATABASE_DUMPS}

copy_drupal_6_database

echo Completed: `date +"%m-%d-%Y at %r"`

exit 0

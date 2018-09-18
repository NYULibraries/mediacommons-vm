#!/bin/bash

die () {
  echo "file: ${0} | line: ${1} | step: ${2} | message: ${3}"
  exit 1
}

function copy_database_dumps() {
  if [ ! -z "$(ls -A ${DATABASE_DUMPS})" ]; then
     rm $DATABASE_DUMPS/*.sql
  fi    
  # To keep things simple, copy all the database dumps.
  rsync -azvh -e "ssh -o ProxyCommand='ssh -W %h:%p ${NETWORK_HOST_USERNAME}@${BASTION_HOST}'" ${NETWORK_HOST_USERNAME}@${SERVER}:${SERVER_DATABASE_DUMPS}/ $DATABASE_DUMPS/
}

function help() {
   echo " "
   echo " Usage: ./copy_database_dumps.sh -u username"
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

# Server
SERVER=mc2.dlib.nyu.edu

# Directory in development server with copies of devmc database dumps
SERVER_DATABASE_DUMPS=/content/prod/pa/drupal/files/mediacommons/databases

# Directory where storing local copies of database dumps
DATABASE_DUMPS=/vagrant/data/databases

mkdir -p ${DATABASE_DUMPS}

copy_database_dumps

echo Completed: `date +"%m-%d-%Y at %r"`

exit 0

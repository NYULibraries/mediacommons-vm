#!/bin/bash

die () {
  echo "file: ${0} | line: ${1} | step: ${2} | message: ${3}";
  exit 1
}

function help() {
   echo " "
   echo " Usage: ./after_init.sh -u username"
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

/vagrant/scripts/configure_alias.sh

/vagrant/scripts/copy_database_dumps.sh -u ${NETWORK_HOST_USERNAME}

/vagrant/scripts/import_database_dump.sh

/vagrant/scripts/copy_sites.sh -u ${NETWORK_HOST_USERNAME}

/vagrant/scripts/clean_cache.sh

/vagrant/scripts/solr.sh

echo Completed: `date +"%m-%d-%Y at %r"`

exit 0

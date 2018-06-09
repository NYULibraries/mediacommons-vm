#!/bin/bash

# I need to check the hostname and prevent the user from running the scipt if the user
# is trying to run the script in a host other that madiacommons.local.

die () {
  echo "file: ${0} | line: ${1} | step: ${2} | message: ${3}"
  exit 1
}

function copy_sites() {
  echo "Copy sites"
  for site in ${ALL_SITES[*]}
    do
      database=$( echo $site | sed 's/-//' )
      copy_site ${site} ${database}
  done
}

function copy_site() {
  site=${1}
  database=${2}
  mkdir -p /vagrant/builds/${site}/sites/default
  chmod 2775 /vagrant/builds/${site}/sites/default
  rsync -azvhLK --delete -e "ssh -o ProxyCommand='ssh -W %h:%p ${NETWORK_HOST_USERNAME}@b.dlib.nyu.edu'" ${NETWORK_HOST_USERNAME}@devmc2.dlib.nyu.edu:/www/sites/mediacommons/builds/$site/sites/default/ /vagrant/builds/${site}/sites/default/
  echo "\$databases['default']['default']['database'] = '$database'; \$databases['default']['default']['username'] = 'root'; \$databases['default']['default']['password'] = 'root'; \$cookie_domain = '.mediacommons.local'; \$conf['file_temporary_path'] = '/tmp';" >> /vagrant/builds/${site}/sites/default/settings.php
}

function help() {
   echo " "
   echo " Usage: ./copy_sites.sh -u username"
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

# Mediacommons main site and channel sites
ALL_SITES=( mediacommons alt-ac fieldguide imr intransition tne )

copy_sites ${ALL_SITES}

echo Completed: `date +"%m-%d-%Y at %r"`

exit 0

#!/bin/bash

function import_database_dump() {
  echo "Importing databases"
  for site in ${ALL_SITES[*]}
    do
      database=$( echo $site | sed 's/-//' )
      mysql -e "DROP DATABASE IF EXISTS ${database}"
      mysql -e "CREATE DATABASE ${database} CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci"
      mysql $database < /vagrant/data/databases/${database}.sql
      echo "Import database ${database} dump done."
  done
}

# Mediacommons main site and channel sites
ALL_SITES=( mediacommons alt-ac fieldguide imr intransition tne )

import_database_dump

echo Completed: `date +"%m-%d-%Y at %r"`

exit 0

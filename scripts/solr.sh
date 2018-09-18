#!/bin/bash

# Defined in ~/.bashrc, but can be overwritten
# PROJECT=mediacommons

# Defined in ~/.bashrc, but can be overwritten
# APP_DIR=/vagrant

# Defined in ~/.bashrc, but can be overwritten
# DRUSH=${APP_DIR}/source/mediacommons/bin/drush-6.7.0/drush

# Defined in ~/.bashrc, but can be overwritten
# HOST=mediacommons.local

# Defined in ~/.bashrc, but can be overwritten
# PROTOCOL=http

# Defined in ~/.bashrc, but can be overwritten
# BUILD_PATH=/var/www/sites/${PROJECT}/builds

# Defined in ~/.bashrc, but can be overwritten
# SOLR_CORE=http://mediacommons.local:8983/solr/mediacommons

echo "Reset Apache Solr index"

curl "${SOLR_CORE}/update?stream.body=<delete><query>*:*</query></delete>&commit=true&wt=json"

# Mediacommons main site and channel sites
ALL_SITES=( alt-ac fieldguide imr intransition tne )

${DRUSH} -y solr-mark-all --root=${BUILD_PATH}/mediacommons/drupal --uri=${PROTOCOL}://${HOST}

${DRUSH} -y solr-index --root=${BUILD_PATH}/mediacommons/drupal --uri=${PROTOCOL}://${HOST}

for site in ${ALL_SITES[*]}
  do
    # Mark all the documents in the site
    ${DRUSH} -y solr-mark-all --root=${BUILD_PATH}/${site}/drupal --uri=${PROTOCOL}://${HOST}/${site}
    # Run index off all documents
    ${DRUSH} -y solr-index --root=${BUILD_PATH}/${site}/drupal --uri=${PROTOCOL}://${HOST}/${site}
done

${DRUSH} -y solr-metadata --root=${BUILD_PATH}/mediacommons/drupal

for site in ${ALL_SITES[*]}
  do
    ${DRUSH} -d -y solr-metadata --root=${BUILD_PATH}/${site}/drupal --uri=${PROTOCOL}://${HOST}/${site}
done

exit 0

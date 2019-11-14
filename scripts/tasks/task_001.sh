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

# Mediacommons main site and channel sites
ALL_SITES=( alt-ac fieldguide imr intransition tne )

${DRUSH} -y dis admin_views --root=${BUILD_PATH}/mediacommons/drupal --uri=${PROTOCOL}://${HOST}
${DRUSH} -y cc all --root=${BUILD_PATH}/mediacommons/drupal --uri=${PROTOCOL}://${HOST}

for site in ${ALL_SITES[*]}
  do
    ${DRUSH} -y dis admin_views --root=${BUILD_PATH}/${site}/drupal --uri=${PROTOCOL}://${HOST}/${site}  
    ${DRUSH} -y cc all --root=${BUILD_PATH}/${site}/drupal --uri=${PROTOCOL}://${HOST}/${site}
done

echo Completed: `date +"%m-%d-%Y at %r"`

exit 0

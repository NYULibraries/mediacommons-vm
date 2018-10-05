#!/bin/bash

# Defined in ~/.bashrc, but can be overwritten
# DRUSH=${APP_DIR}/source/mediacommons/bin/drush-6.7.0/drush

# Defined in ~/.bashrc, but can be overwritten
# HOST=mediacommons.local

# Defined in ~/.bashrc, but can be overwritten
# PROTOCOL=http

# Defined in ~/.bashrc, but can be overwritten
# BUILD_PATH=/var/www/sites/${PROJECT}/builds

echo "Revert all features"

# Mediacommons main site and channel sites
ALL_SITES=( alt-ac fieldguide imr intransition tne )

${DRUSH} -y features-revert-all --root=${BUILD_PATH}/mediacommons/drupal --uri=${PROTOCOL}://${HOST}

for site in ${ALL_SITES[*]}
  do
    ${DRUSH} -y features-revert-all --root=${BUILD_PATH}/${site}/drupal --uri=${PROTOCOL}://${HOST}/${site}
done

exit 0

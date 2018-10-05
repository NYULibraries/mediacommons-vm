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

ALL_SITES=( alt-ac fieldguide imr intransition tne )

ALL_REPOS=( mediacommons_admin  mediacommons_modules  mediacommons_projects  mediacommons_theme  mediacommons_umbrella )

BRANCH=develop

for repo in ${ALL_REPOS[*]}
  do
    cd ${APP_DIR}/source/${repo} && \
       git stash && \
       git checkout ${branch} && \
       git pull
done

for site in ${ALL_SITES[*]}
  do
    cd ${BUILD_PATH}/${site} && \
      git stash && \
      git pull
    ${DRUSH} -y updb --root=${BUILD_PATH}/${site}/drupal --uri=${PROTOCOL}://${HOST}/${site} && \
      ${DRUSH} -y cron --root=${BUILD_PATH}/${site}/drupal --uri=${PROTOCOL}://${HOST}/${site}    
    cd -
done

cd ${APP_BUILDS_DIR}/mediacommons && \
   git stash && \
   git pull

${DRUSH} -y updb --root=${BUILD_PATH}/mediacommons/drupal --uri=${PROTOCOL}://${HOST} && \
  ${DRUSH} -y cron --root=${BUILD_PATH}/mediacommons/drupal --uri=${PROTOCOL}://${HOST} 

cd -

exit 0

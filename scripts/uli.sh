#!/bin/bash

# Defined in ~/.bashrc, but can be overwritten
# PROJECT=mediacommons

# Defined in ~/.bashrc, but can be overwritten
# APP_DIR=/vagrant

# Defined in ~/.bashrc, but can be overwritten
# BUILD_PATH=/var/www/sites/mediacommons/builds

${DRUSH} uli --root=${BUILD_PATH}/mediacommons/drupal

exit 0

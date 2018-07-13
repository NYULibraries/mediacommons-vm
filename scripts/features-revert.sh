#!/bin/bash

die () {
  echo "file: ${0} | line: ${1} | step: ${2} | message: ${3}";
  exit 1
}

echo "Revert all features"

# Mediacommons main site and channel sites
ALL_SITES=( alt-ac fieldguide imr intransition tne )

/vagrant/code/mediacommons/bin/drush -y features-revert-all --root=/var/www/drupalvm/builds/mediacommons --uri=http://mediacommons.local

for site in ${ALL_SITES[*]}
  do
    /vagrant/code/mediacommons/bin/drush -y features-revert-all --root=/var/www/drupalvm/builds/${site} --uri=http://mediacommons.local/${site}
done

exit 0

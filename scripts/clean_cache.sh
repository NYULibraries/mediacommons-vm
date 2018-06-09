#!/bin/bash

# Mediacommons main site and channel sites
ALL_SITES=( alt-ac fieldguide imr intransition tne )

/vagrant/code/mediacommons/bin/drush -y cc all --root=/var/www/drupalvm/builds/mediacommons --uri=http://mediacommons.local
/vagrant/code/mediacommons/bin/drush -y cron --root=/var/www/drupalvm/builds/mediacommons --uri=http://mediacommons.local
/vagrant/code/mediacommons/bin/drush -y status --root=/var/www/drupalvm/builds/mediacommons --uri=http://mediacommons.local

for site in ${ALL_SITES[*]}
  do
    /vagrant/code/mediacommons/bin/drush -y cc all --root=/var/www/drupalvm/builds/${site} --uri=http://mediacommons.local/${site}
    /vagrant/code/mediacommons/bin/drush -y cron --root=/var/www/drupalvm/builds/${site} --uri=http://mediacommons.local/${site}
    /vagrant/code/mediacommons/bin/drush -y status --root=/var/www/drupalvm/builds/${site} --uri=http://mediacommons.local/${site}
done

echo Completed: `date +"%m-%d-%Y at %r"`

exit 0

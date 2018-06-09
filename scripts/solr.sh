#!/bin/bash

die () {
  echo "file: ${0} | line: ${1} | step: ${2} | message: ${3}";
  exit 1
}

echo "Reset Apache Solr index"

curl "http://mediacommons.local:8983/solr/mediacommons/update?stream.body=<delete><query>*:*</query></delete>&commit=true&wt=json"

# Mediacommons main site and channel sites
ALL_SITES=( alt-ac fieldguide imr intransition tne )

/vagrant/code/mediacommons/bin/drush -y solr-mark-all --root=/var/www/drupalvm/builds/mediacommons --uri=http://mediacommons.local

/vagrant/code/mediacommons/bin/drush -y solr-index --root=/var/www/drupalvm/builds/mediacommons --uri=http://mediacommons.local

for site in ${ALL_SITES[*]}
  do
    # Mark all the documents in the site
    /vagrant/code/mediacommons/bin/drush -y solr-mark-all --root=/var/www/drupalvm/builds/${site} --uri=http://mediacommons.local/${site}
    # Run index off all documents
    /vagrant/code/mediacommons/bin/drush -y solr-index --root=/var/www/drupalvm/builds/${site} --uri=http://mediacommons.local/${site}
done

/vagrant/code/mediacommons/bin/drush -y solr-metadata --root=${BUILD_APP_ROOT}/builds/mediacommons

for site in ${ALL_SITES[*]}
  do
    /vagrant/code/mediacommons/bin/drush -d -y solr-metadata --root=/var/www/drupalvm/builds/${site} --uri=http://mediacommons.local/${site}
done

exit 0

set -u

SOLR_UID=${SOLR_UID:-8983}
SOLR_GID=${SOLR_GID:-8983}

groupmod -o -g "${SOLR_GID}" solr
usermod -o -u "${SOLR_UID}" solr
chown -R solr:solr /opt/goobiviewer /opt/solr /opt/solr-9.8.0-slim /opt/java /var/solr

exec gosu solr solr-foreground
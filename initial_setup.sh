#!/usr/bin/env bash
echo "Waiting for solr to start"
wait-for-solr.sh --max-attempts 1000 --wait-seconds 2
RESULT=$(curl -s http://localhost:8983/solr/admin/collections?action=list | grep "collection1")
if [ -z $RESULT ]; then
    echo "Performing initial setup"
    /opt/solr/bin/solr zk -z zookeeper upconfig -n goobiviewer -d /opt/goobiviewer
    /opt/solr/bin/solr create -c collection1 -n goobiviewer
else
    echo "Initial setup skipped due to existing collection"
fi

#!/usr/bin/env bash
echo "Waiting for solr to start"
wait-for-solr.sh --max-attempts 1000 --wait-seconds 2
RESULT=$(curl -s http://localhost:8983/solr/admin/collections?action=list | grep "collection1")
if [ -z $RESULT ]; then
    echo "Performing initial setup"
    while true; do
        echo "Trying to perform Solr configuration setup with zookeeper ..."
        /opt/solr/bin/solr zk upconfig -z zookeeper -n goobiviewer -d /opt/goobiviewer

        if [ $? -eq 0 ]; then
            echo "Solr configuration setup with zookeeper successfull!"
            break
        else
            echo "Error perform Solr configuration setup with zookeper, retrying"
            sleep 5
        fi
    done
    while true; do
        echo "Trying to create Solr collection for viewer ..."
        /opt/solr/bin/solr create -c collection1 -n goobiviewer

        if [ $? -eq 0 ]; then
            echo "Solr collection successfully created!"
            break
        else
            echo "Error creating Solr collection, retrying"
            sleep 5
        fi
    done
else
    echo "Initial setup skipped due to existing collection"
fi

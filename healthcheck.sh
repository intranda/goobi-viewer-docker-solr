#!/bin/bash

# Überprüfe, ob die Kollektion 'collection1' existiert
curl --silent --fail "http://localhost:8983/solr/admin/collections?action=LIST" | grep -q 'collection1'

# Wenn die Kollektion nicht gefunden wird, fehlerhaft zurückkehren
if [ $? -ne 0 ]; then
  exit 1
fi

# Ansonsten erfolgreich zurückkehren
exit 0

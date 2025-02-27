# solr-docker

Docker image creation for Apache Solr including libraries as needed for the Goobi Viewer

## Update instructions
- Change Solr version in `Dockerfile`
- Extract latest `solrconfig.xml` from Solr and apply necessary patches (adapt to version):
```bash
docker run -it solr:9.8.0 cat /opt/solr-9.8.0/server/solr/configsets/_default/conf/solrconfig.xml > goobiviewer/conf/solrconfig.xml
```
- Download latest [`schema.xml`](https://gitea.intranda.com/goobi-viewer/goobi-viewer-indexer/raw/branch/master/goobi-viewer-indexer/src/main/resources/other/schema.xml) and place it in `goobiviewer/conf`.

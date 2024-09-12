
FROM solr:9.5.0
LABEL org.opencontainers.image.authors="Matthias Geerdsen <matthias.geerdsen@intranda.com>"
LABEL org.opencontainers.image.source="https://github.com/intranda/goobi-viewer-docker-solr"
LABEL org.opencontainers.image.description="Goobi viewer - preconfigured Apache Solr"

ADD https://github.com/locationtech/jts/releases/download/1.17.0/jts-core-1.17.0.jar /opt/solr/server/lib/jts-core-1.17.0.jar
ADD https://raw.githubusercontent.com/locationtech/jts/master/LICENSE_EDLv1.txt /opt/solr/licenses/jts-LICENSE_EDLv1.txt
USER 0
RUN chmod a+r /opt/solr/server/lib/jts-core-1.17.0.jar
USER 8983
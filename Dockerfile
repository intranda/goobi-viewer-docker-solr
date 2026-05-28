FROM solr:9.8.0
LABEL org.opencontainers.image.authors="Matthias Geerdsen <matthias.geerdsen@intranda.com>"
LABEL org.opencontainers.image.source="https://github.com/intranda/goobi-viewer-docker-solr"
LABEL org.opencontainers.image.description="Goobi viewer - preconfigured Apache Solr"

ADD https://github.com/locationtech/jts/releases/download/1.17.0/jts-core-1.17.0.jar /opt/solr/server/lib/jts-core-1.17.0.jar
ADD https://raw.githubusercontent.com/locationtech/jts/master/LICENSE_EDLv1.txt /opt/solr/licenses/jts-LICENSE_EDLv1.txt

USER 0
RUN apt-get update && apt-get install -y patch
RUN chmod a+r /opt/solr/server/lib/jts-core-1.17.0.jar

# cannot add -XX:+ZGenerational to flags since it was introduced in java 21, defaulted in 23 and removed in 24 (implicit, default) but solr 9.8 uses java 17
ENV SOLR_HEAP="2048m"
ENV GC_TUNE="-XX:+UseZGC \
            -XX:+ExplicitGCInvokesConcurrent \
            -XX:+AlwaysPreTouch"
ENV SOLR_LOG_LEVEL="ERROR"
ENV SOLR_MODULES="analysis-extras"

COPY patches/* /tmp/patches/

RUN mkdir -p /opt/goobiviewer
RUN cp -r /opt/solr/server/solr/configsets/_default/conf /opt/goobiviewer/conf
COPY config /opt/goobiviewer/conf
RUN cat /opt/goobiviewer/conf/lang/stopwords_de.txt /opt/goobiviewer/conf/lang/stopwords_en.txt > /opt/goobiviewer/conf/lang/stopwords.txt
RUN patch --output /opt/goobiviewer/conf/solrconfig.xml /opt/solr/server/solr/configsets/_default/conf/solrconfig.xml < /tmp/patches/solrconfig.xml.patch
RUN rm /opt/goobiviewer/conf/managed-schema.xml
RUN rm -r /tmp/patches

COPY call_initial_setup.sh /docker-entrypoint-initdb.d/
COPY healthcheck.sh /
COPY initial_setup.sh /
COPY run.sh /
HEALTHCHECK --interval=60s --timeout=15s --start-period=15s --retries=10 CMD [ "/healthcheck.sh" ]

CMD ["/run.sh"]
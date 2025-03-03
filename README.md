# solr-docker
Docker image creation for Apache Solr including libraries as needed for the Goobi Viewer

## Usage
In order to use this image, Zookeeper is required and needs to be configured via environment variables:
```yml
services:
  solr:
    image: ghcr.io/intranda/goobi-viewer-docker-solr
    depends_on:
      - zookeeper
    restart: unless-stopped
    environment:
      ZK_HOST: zookeeper:2181 # This setting must match the zookeeper service name
      TZ: Europe/Berlin
      # for further configuration check documentation of official Solr docker image
    volumes:
      - type: volume
        source: persistent-solr-data-volume
        target: /var/solr
    ports:
      - 8983:8983

  zookeeper:
    image: zookeeper:3.9.3
    restart: unless-stopped
    environment:
      TZ: Europe/Berlin
    volumes:
      - type: volume
        source: persistent-zookeeper-data-volume
        target: /data

volumes:
  persistent-solr-data-volume:
  persistent-zookeeper-data-volume:
```

## Schema update instructions
- Make changes to the `config/schema.xml` as required.

## Solr update instructions
- Change version of Solr image in first line of `Dockerfile`.
- Adapt Patches in `patches/` directory, if necessary.

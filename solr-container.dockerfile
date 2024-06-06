ARG SOLR_IMAGE
FROM ${SOLR_IMAGE}
COPY --chown=solr:solr data/solr /var/solr/data

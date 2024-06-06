FROM ca0abinary/sql-solr:latest AS build
ARG  ACCEPT_EULA=Y
ARG  SA_PASSWORD=P@ssword123
ARG  MSSQL_MEMORY_LIMIT_MB=1024
ARG  SOLR_OPTS=-Djetty.host=localhost
COPY data/solr_export.bak /data/
COPY cores/ /var/solr/data/
RUN  set -xe \
  # Start solr
  && solr start -force \
  # Restore SQL Server backup
  && (/opt/mssql/bin/sqlservr -c &) \
  # Wait for SQL startup
  && (while ! nc -z 127.0.0.1 1433; do sleep 10; echo "Waiting for SQL Server"; done) && sleep 10 \
  # Restore backup
  && ~/go/bin/usql mssql://sa:$SA_PASSWORD@localhost/master --command "RESTORE DATABASE [solr_export] FROM DISK = N'/data/solr_export.bak' WITH MOVE 'solr_export' to '/var/opt/mssql/data/solr_export.mdf', move 'solr_export_log' to '/var/opt/mssql/data/solr_export.ldf'" \
  # Use DIH to load cores to Solr from local SQL server
  && bash /opt/docker-solr/scripts/wait-for-solr-load.sh MyCore1 \
  && bash /opt/docker-solr/scripts/wait-for-solr-load.sh MyCore2 \
  # Cleanup
  && solr stop \
  && chown -R solr:solr /var/solr

FROM solr:8.11.3-slim
COPY --from=build /var/solr /var/solr

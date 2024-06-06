#!/usr/bin/env bash
set -e

pushd $(dirname $BASH_SOURCE)

cat <<EOF > /tmp/restore.sql
RESTORE DATABASE [solr_export]
  FROM DISK = N'/data/solr_export.bak'
  WITH MOVE 'solr_export' TO '/var/opt/mssql/data/solr_export.mdf',
       MOVE 'solr_export_log' TO '/var/opt/mssql/data/solr_export.ldf'
EOF

/opt/mssql-tools/bin/sqlcmd -U sa -P P@ssword123 -S mssql -d master -i /tmp/restore.sql
touch /tmp/restore.done

echo "[$(date)] Restore of SQL database complete. Sleeping forever.";
sleep inf

popd

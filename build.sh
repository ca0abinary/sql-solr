#!/usr/bin/env bash
set -e

pushd $(dirname $BASH_SOURCE)

source .env

docker compose down -t 0
rm -fr data
mkdir -p data/{mssql,solr}
docker compose up -d

while true; do
    READY=$(docker ps --all --filter "label=core_loader" --filter "label=com.docker.compose.project=sql-solr" --format '{{ .Status }}' | grep -v 'Exited' || echo "")
    STATUS=$(docker ps --all --filter "label=core_loader" --filter "label=com.docker.compose.project=sql-solr" --format '{{ .Status }}' | grep -v '(0)' || echo "")

    echo "[$(date)] Waiting for core loaders to complete"
    if [[ -z "$READY" && -z "$STATUS" ]]; then
        break
    fi

    if [[ -z "$READY" ]]; then
        echo "[$(date)] One or more core loaders failed"
        exit 1
    fi

    sleep 5
done

docker build -t solr-container -f solr-container.dockerfile --build-arg="SOLR_IMAGE=${SOLR_IMAGE}" .
docker compose down -t 0

popd

#!/bin/bash
set -ex

echo "[$(date)] Starting core load for $1";
wget -qO- "http://solr:8983/solr/$1/dataimport?command=full-import&clean=true&commit=true&optimize=true&wt=json"
while true; do
    sleep 10;
    echo "[$(date)] Waiting for $1 core load to complete";
    CORE_STATUS_JSON=$(wget -qO- "http://solr:8983/solr/$1/dataimport?command=status&wt=json")
    CORE_STATUS=$(echo $CORE_STATUS_JSON  | jq -r '.statusMessages | with_entries(select(.key == "")) | .""')
    echo $CORE_STATUS;
    case "$CORE_STATUS" in
        *"completed"*) exit 0 ;;
        *"failed"*) exit 1 ;;
        *) ;;
    esac
done

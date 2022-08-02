#!/bin/bash
set -e
wget -nv -O- "http://localhost:8983/solr/$1/dataimport?command=full-import&clean=true&commit=true&optimize=true&wt=json"
sleep 10;
while true; do
    echo "[$(date)] Waiting for $1 core load to complete";
    CORE_STATUS=$(wget -qO- "http://localhost:8983/solr/$1/dataimport?command=status&wt=json" | tr '\n' ' ');
    echo $CORE_STATUS;
    if [[ $CORE_STATUS = *"Full Import failed"* ]]; then exit -1; fi;
    if [[ ! $CORE_STATUS = *"busy"* ]]; then break; fi;
    sleep 10;
done

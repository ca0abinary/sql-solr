#!/bin/bash
docker buildx build --platform linux/amd64,linux/arm64 -t ca0abinary/sql-solr:8.11.1 --push .

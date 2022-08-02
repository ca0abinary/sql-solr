#!/bin/bash
set -xe

# Use podman if it's installed, otherwise docker
DOCKER=docker
if [[ -x $(command -v podman) ]]; then
  DOCKER=podman
fi

# Build the base container
pushd ..
$DOCKER build -t sql-solr .

# Build the materialized solr server from SQL data
popd
$DOCKER build --ulimit nofile=65000 --ulimit nproc=65000 -t example .

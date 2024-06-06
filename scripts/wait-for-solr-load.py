#!/usr/bin/env python
import docker

client = docker.from_env()
while True:
    try:
        core_loaders = client.list(
            all=True, containers=True,
            filters=[{'label': 'solr-core-loader'},
                     {'label': 'com.docker.compose.project=sql-solr'}])
    except docker.errors.NotFound:
        print("No core loaders found")
        exit(1)
    except docker.errors.APIError as e:
        print(f"Error while fetching core loaders: {e}")
        exit(2)

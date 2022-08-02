#!/bin/bash
if [[ ! `ps aux` = *sqlservr* ]]; then
    /opt/mssql/bin/sqlservr -c &
    while ! nc -z 127.0.0.1 1433; do 
        sleep 1
        echo "Waiting for SQL Server"
    done
fi

# Microsoft SQL Server & Solr Hybrid Container

This is the unholy love child of microsoft sql server and solr docker images

At its core this is just the Dockerfile and scripts from github.com/docker-solr/docker-solr/tree/master/`version`/slim with the sql server as base image, [usql](https://github.com/xo/usql) added, and the minimal changes needed to make it all work on both intel and arm architectures.

The objective of this container is to support the following build process:

1. Start SQL Server
2. Start Solr
3. BCP data into the local SQL server from a file
4. DIH import that data into a Solr core
5. Copy that data from this build-container to an empty solr:8.9.0-slim container for deployment

## Example Usage

Setup an environment with the following folders

- `data/` Contains the sql backup file to restore (in the following example it's named `solr_export.bak`)
- `cores/` Contains the solr core definition folders (one folder for each core)
  - In the example below the cores `MyCore1`,`MyCore2`,`MyCore3`, and `MyCore4` are loaded using the `wait-for-solr-load.sh` script included in this container
  - This process uses Solr's [DataImportHandler](https://cwiki.apache.org/confluence/display/solr/dataimporthandler) so a DIH configuration must be a part of your solr core definition.
    - Example `data-config.xml`

      ```xml
      <?xml version="1.0" encoding="UTF-8" ?>
      <dataConfig>
          <dataSource driver="com.microsoft.sqlserver.jdbc.SQLServerDriver" url="jdbc:sqlserver://localhost;databaseName=solr_export;user=sa;password=P@ssword123;" batchSize="10000" responseBuffering="adaptive" selectMethod="cursor"/>
          <document>
              <entity pk="Id" name="MyDataTable" query="SELECT * FROM MyDataTable;"/>
          </document>
      </dataConfig>
      ```

  - Create a Dockerfile similar to [this one](example/Dockerfile).

The build process will result in a runnable solr instance containing the data from SQL.

An [example](example/build-example.sh) is available.

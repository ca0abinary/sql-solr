# Compose a Solr Server from a MSSQL Database

This project uses docker-compose to build one or more Solr search cores from data retrieved from a Microsoft SQL Server backup.

## Example Usage

Run the build script to build an example solr server container:

```sh
./build.sh
```

To test the server we will run the resulting container the server of which will be available at [http://localhost:8983](http://localhost:8983).

```sh
docker run --rm -it -p 8983:8983 solr-container
```

## How it works

The heart of this process lives in the [docker-compose.yaml](./docker-compose.yaml) which follows these steps:

1. `mssql` gets the Microsoft SQL Server container and waits for it to be available
   - The version comes from the `.env` file
   - This step operates in parallel with the `solr` step
2. `solr` gets the Solr server container and waits for it to be available
   - The version comes from the `.env` file
   - This step operates in parallel with the `mssql` step
3. `step1_restore_db` restores the backed up MSSQL database file
   - In the example it comes from `example/data/solr_export.bak`
   - All other steps wait for this to complete
4. The remaining `load_core` steps perform the actual data load from SQL to Solr
   - Both these steps and the restore_db are the ones you want to modify for your project

`build.sh` wraps teh docker compose process and adds building the final container.

## How do I make this my own?

1. Fork this repo
2. Create your own cores and data (use the example folder as a base)
   1. Edit `core.properties` to name your core
   2. Edit `conf/data-config.xml` to modify the data load parameters
3. Edit the `docker-compose.yaml` to make sure your core(s) load
    - The `&load_core` and `<<: *load_core` statements help make the yaml easier to read by performing a "copy & paste" operation that allows for modification.

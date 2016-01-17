OrientDB running in a Docker container.

## Usage

This configuration requires that the database *root* user password is set as an
environment variable (`ODB_ADMIN_PASSWORD`).

To run OrientDB:

    $ docker run \
      -e ODB_ADMIN_PASSWORD=password \
      -p 2480:2480 \
      -p 2424:2424 \
      humangeo/orientdb

This will run OrientDB on the default ports, but will loose data when the
container is shutdown. To persist data across container restarts, you will
need to map the `/opt/orientdb/databases` directory to your host file system.

To mount a local database directory with Docker:

    $ docker run \
      -e ODB_ADMIN_PASSWORD=password \
      -p 2480:2480 \
      -p 2424:2424 \
      -v <db-path>/dabases:/opt/orientdb/databases \
      humangeo/orientdb

If you need to customize the configuration further, you can map
`/opt/orientdb/{config,databases,backup}` to local directories on the host file
system.

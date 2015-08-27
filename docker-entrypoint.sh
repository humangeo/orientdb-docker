#!/bin/sh -e
ORIENTDB_HOME=/opt/orientdb
ODB_ADMIN_USER=${ODB_ADMIN_USER:-root}


# fail if there is no config file
if [ ! -f $ORIENTDB_HOME/config/orientdb-server-config.xml ]; then
  echo >&2 'error: no database config found!'
  exit 1
fi


if [ "$1" != '/opt/orientdb/bin/console.sh' ]; then
  # fail if user did not provide default admin password
  if [ -z "$ODB_ADMIN_PASSWORD" ]; then
    echo >&2 'error: OrientDB admin user password is not set!'
    echo >&2 '  Did you forget to add -e ODB_ADMIN_PASSWORD=... ?'
    exit 1
  fi


  # add a default admin user
  mv $ORIENTDB_HOME/config/orientdb-server-config.xml $ORIENTDB_HOME/config/orientdb-server-config.xml.orig
  sed "/<users>/,/<\/users>/{
    # insert new user info after opening tag.
    /<users>/{
      s|$|\\
        <user name=\"$ODB_ADMIN_USER\" password=\"$ODB_ADMIN_PASSWORD\" resources=\"*\" />|
      b
    }

    # skip closing tag
    /<\/users>/b

    # delete old user config
    d
  }" $ORIENTDB_HOME/config/orientdb-server-config.xml.orig > $ORIENTDB_HOME/config/orientdb-server-config.xml

  # backup the previous config file
  gzip -f $ORIENTDB_HOME/config/orientdb-server-config.xml.orig
fi

exec "$@"

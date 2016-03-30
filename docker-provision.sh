#!/bin/sh -eu
ORIENTDB_VERSION="2.1.14"
ORIENTDB_HOME=/opt/orientdb
ORIENTDB_DOWNLOAD_URL=http://central.maven.org/maven2/com/orientechnologies/orientdb-community/$ORIENTDB_VERSION
BUILD_PACKAGES="curl"

# Add Debian Backports repository...needed for OpenJDK 8
cat <<EOF > /etc/apt/sources.list.d/backports.list
# Debian "Jessie" Backports repository
deb http://http.debian.net/debian jessie-backports main
EOF

# update Apt repositories
apt-get update


# install supervisord
apt-get -y install supervisor
mkdir -p /var/log/supervisor

# use custom configuration to start OrientDB w/supervisord
cat <<EOF > /etc/supervisor/conf.d/supervisord.conf
[supervisord]
nodaemon=true

[program:orientdb]
command=/opt/orientdb/bin/server.sh
autostart=true
autorestart=true
stderr_logfile=/var/log/orientdb.err.log
stdout_logfile=/var/log/orientdb.out.log
EOF


# install remaining OrientDB dependencies
# see: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-orientdb-on-an-ubuntu-12-04-vps
#apt-get -y install openjdk-8-jdk
apt-get -y install openjdk-8-jre-headless


# add installation dependencies
apt-get -y install $BUILD_PACKAGES


# Install OrientDB w/default config, but without the sample databases and backup
# directories. This allows the database to be run as-as, but if to persist data
# across restarts the databases and config directories can be mapped to the local
# file system.
for f in $ORIENTDB_DOWNLOAD_URL/orientdb-community-$ORIENTDB_VERSION.tar.{gz,gz.md5,gz.sha1}; do
  curl -J -O $f
done
(cat orientdb-community-$ORIENTDB_VERSION.tar.gz.md5 ; echo " orientdb-community-$ORIENTDB_VERSION.tar.gz") | md5sum -c -
(cat orientdb-community-$ORIENTDB_VERSION.tar.gz.sha1 ; echo " orientdb-community-$ORIENTDB_VERSION.tar.gz") | sha1sum -c -
tar xzf orientdb-community-$ORIENTDB_VERSION.tar.gz
mv orientdb-community-$ORIENTDB_VERSION $ORIENTDB_HOME
rm -rf $ORIENTDB_HOME/databases $ORIENTDB_HOME/backup
rm -f orientdb-community-$ORIENTDB_VERSION.tar.gz*


# add an entrypoint script that will wrap the command
mv /tmp/docker/docker-entrypoint.sh /entrypoint.sh
chmod +x /entrypoint.sh


# remove installation dependencies
apt-get -y purge $BUILD_PACKAGES


# clean up (apt)
apt-get clean     # remove packages that have been downloaded, installed, and no longer needed
apt-get autoclean # remove archived packages that can no longer be downloaded


# clean up (misc.)
rm -rf /var/lib/apt/lists/* /var/cache/apt/*

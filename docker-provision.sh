#!/bin/sh -eu
ORIENTDB_VERSION="2.1.6"
ORIENTDB_HOME=/opt/orientdb

# Add Debian Backports repository
cat <<EOF > /etc/apt/sources.list.d/backports.list
# Debian "Jessie" Backports repository
deb http://http.debian.net/debian jessie-backports main
EOF

# update Apt repositories
apt-get update


# install supervisord
apt-get -y install supervisor
mkdir -p /var/log/supervisor


# install remaining OrientDB dependencies
# see: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-orientdb-on-an-ubuntu-12-04-vps
apt-get -y install openjdk-8-jdk


# add installation dependencies
apt-get -y install curl


# Install OrientDB w/default config, but without the sample databases and backup
# directories. This allows the database to be run as-as, but if to persist data
# across restarts the databases and config directories can be mapped to the local
# file system.
cd
curl -J -O http://orientdb.com/download.php?file=orientdb-community-$ORIENTDB_VERSION.tar.gz
tar xzf orientdb-community-$ORIENTDB_VERSION.tar.gz
mv orientdb-community-$ORIENTDB_VERSION $ORIENTDB_HOME
rm -rf $ORIENTDB_HOME/databases $ORIENTDB_HOME/backup
rm -f orientdb-community-$ORIENTDB_VERSION.tar.gz


# remove installation dependencies
apt-get -y purge curl


# clean up (apt)
apt-get clean     # remove packages that have been downloaded, installed, and no longer needed
apt-get autoclean # remove archived packages that can no longer be downloaded


# clean up (misc.)
rm -rf /var/lib/apt/lists/* /var/cache/apt/*

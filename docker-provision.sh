#!/bin/sh -eu
ORIENTDB_VERSION="2.1.2"
ORIENTDB_HOME=/opt/orientdb


# update Apt repositories
apt-get update


# install supervisord
apt-get -y install supervisor
mkdir -p /var/log/supervisor


# install remaining OrientDB dependencies
# see: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-orientdb-on-an-ubuntu-12-04-vps
apt-get -y install openjdk-7-jdk


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
apt-get -y autoremove

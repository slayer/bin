#!/bin/sh -e

echo "deb http://www.apache.org/dist/cassandra/debian 20x main" >/etc/apt/sources.list.d/cassandra.sources.list

gpg --keyserver pgp.mit.edu --recv-keys 4BD736A82B5C1B00
gpg --export --armor 4BD736A82B5C1B00 | apt-key add -


apt-get update
apt-get install cassandra

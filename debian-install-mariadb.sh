#!/bin/sh

sudo apt-get install software-properties-common
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
sudo add-apt-repository 'deb http://mirror.1000mbps.com/mariadb/repo/10.0/ubuntu trusty main'

sudo apt-get update
sudo apt-get install mariadb-server libmariadbclient-dev

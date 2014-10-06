#!/bin/sh


# Update, upgrade and install development tools:
apt-get update
apt-get --force-yes upgrade
apt-get -y install git-core
apt-get -y install build-essential

sudo apt-get install -y autoconf build-essential libxml2-dev libxslt-dev libcurl4-openssl-dev libreadline-dev libreadline6-dev libncurses-dev libgmp-dev libgmp10
sudo apt-get install -y curl libcurl4-openssl-dev imagemagick libpq-dev libssl-dev zlib1g-dev libpcre3-dev libsqlite3-dev
sudo apt-get install -y strace ltrace tcpdump tcpick whois
sudo apt-get install -y ack-grep
sudo apt-get install -y libmysqlclient-dev # libmariadbclient-dev
sudo apt-get install -y etckeeper

# sudo apt-get install -y libmagickcore-dev libmagick++-dev imagemagick

sudo apt-get clean

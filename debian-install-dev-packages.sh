#!/bin/sh


# Update, upgrade and install development tools:
apt-get update
apt-get --force-yes upgrade
apt-get -y install git-core
apt-get -y install build-essential
locale-gen ru_RU.UTF-8 ru_UA.UTF-8

sudo apt-get install -y autoconf build-essential libxml2-dev libxslt-dev libmysqlclient-dev libcurl4-openssl-dev libreadline-dev libreadline6-dev
sudo apt-get install -y curl libcurl4-openssl-dev imagemagick libpq-dev libssl-dev zlib1g-dev
sudo apt-get install -y pwgen stow strace ltrace tcpdump tcpick whois dnsutils


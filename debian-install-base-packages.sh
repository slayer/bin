#!/bin/sh -e

BASE_PACKAGES="etckeeper tmux colordiff ctags vim dnsutils whois mtr-tiny curl"

apt-get update
apt-get --force-yes upgrade
locale-gen ru_RU.UTF-8 ru_UA.UTF-8
apt-get -y install git-core

apt-get -y install $BASE_PACKAGES

#!/bin/sh -e

BASE_PACKAGES="etckeeper tmux grc colordiff sudo ctags vim dnsutils whois mtr-tiny curl pwgen whois stow dnsutils mbuffer"

apt-get update
apt-get --force-yes upgrade
locale-gen ru_RU.UTF-8 ru_UA.UTF-8
apt-get -y install git-core

apt-get -y install $BASE_PACKAGES
apt-get clean

echo "vlad ALL=NOPASSWD: ALL" >>/etc/sudoers

sed -i 's/^VCS=.*$/VCS=git/' /etc/etckeeper/etckeeper.conf
cd /etc
etckeeper init && etckeeper commit "initial"

if [ `readlink /bin/sh` != bash ]; then
	ln -sf /bin/bash /bin/sh
fi



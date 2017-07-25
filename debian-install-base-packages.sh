#!/bin/bash -e

user=`whoami`

BASE_PACKAGES="etckeeper tmux grc sudo ctags vim dnsutils whois mtr-tiny curl pwgen whois stow dnsutils htop"
USEFULL_PACKAGES="pv colordiff mbuffer"

apt-get update
apt-get -y upgrade
locale-gen ru_RU.UTF-8 ru_UA.UTF-8 uk_UA.UTF-8
apt-get -y install git-core

apt-get -y install $BASE_PACKAGES
apt-get clean

if [ "$user" != root ]; then
  echo "$user ALL=NOPASSWD: ALL" >>/etc/sudoers
else
  echo "vlad ALL=NOPASSWD: ALL" >>/etc/sudoers
fi

sed -i 's/^VCS=.*$/VCS=git/' /etc/etckeeper/etckeeper.conf
cd /etc
etckeeper init && etckeeper commit "initial"

if [ `id -u` = 0 ]; then
  git config --global user.email root@`hostname`
  git config --global user.name root
fi

if [ `readlink /bin/sh` != bash ]; then
	ln -sf /bin/bash /bin/sh
fi

# Auto apt-get upgrade
if [ `id -u` = 0 -a ! -f /etc/cron.daily/apt-get-upgrade ]; then
	echo -e '#!/bin/sh\n\nexport DEBIAN_FRONTEND=noninteractive \napt-get -q update >/dev/null 2>/dev/null && apt-get -yqq upgrade >/dev/null 2>/dev/null' >/etc/cron.daily/apt-get-upgrade
	chmod a+x /etc/cron.daily/apt-get-upgrade
fi



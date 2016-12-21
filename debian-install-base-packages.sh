#!/bin/bash -e

BASE_PACKAGES="etckeeper tmux grc colordiff sudo ctags vim dnsutils whois mtr-tiny curl pwgen whois stow dnsutils mbuffer fail2ban htop"

apt-get update
apt-get -y upgrade
locale-gen ru_RU.UTF-8 ru_UA.UTF-8 uk_UA.UTF-8
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

# Auto apt-get upgrade
if [ `id -u` = 0 -a ! -f /etc/cron.daily/apt-get-upgrade ]; then
	echo -e '#!/bin/sh\n\napt-get -q update >/dev/null 2>/dev/null && apt-get -yqq upgrade >/dev/null 2>/dev/null' >/etc/cron.daily/apt-get-upgrade
	chmod a+x /etc/cron.daily/apt-get-upgrade
fi



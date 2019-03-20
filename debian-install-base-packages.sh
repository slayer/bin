#!/bin/bash -e

user=`whoami`

BASE_PACKAGES="etckeeper tmux grc sudo ctags vim dnsutils whois mtr-tiny curl pwgen whois stow "
BASE_PACKAGES="${BASE_PACKAGES} dnsutils htop iputils-ping pbzip2"
USEFULL_PACKAGES="pv colordiff mbuffer silversearcher-ag"

apt-get update
apt-get -y upgrade
which locale-gen && locale-gen ru_RU.UTF-8 ru_UA.UTF-8 uk_UA.UTF-8
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

# cron apt upgrade/autoremove
if [ `id -u` = 0 -a ! -f /etc/cron.daily/apt-upgrade ]; then
  [ -f /etc/cron.daily/apt-get-upgrade ] && rm -f /etc/cron.daily/apt-get-upgrade
  cat > /etc/cron.daily/apt-upgrade <<END
#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
apt -qqq update >/dev/null 2>/dev/null && apt -yqqq upgrade >/dev/null 2>/dev/null
apt -qqqy autoremove

END
	chmod a+x /etc/cron.daily/apt-upgrade
fi

# dpkg --get-selections
if [ `id -u` = 0 ]; then
  cat > /etc/cron.daily/dpkg-get-selections <<END
#!/bin/sh

dpkg --get-selections >/etc/apt/dpkg-get-selections

END
	chmod a+x /etc/cron.daily/dpkg-get-selections
fi

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install



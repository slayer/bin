#!/bin/bash -e

user=`whoami`
export DEBIAN_FRONTEND=noninteractive

BASE_PACKAGES="etckeeper tmux grc sudo vim dnsutils whois mtr-tiny curl pwgen whois stow net-tools"
BASE_PACKAGES="${BASE_PACKAGES} dnsutils htop iputils-ping pbzip2 rsync dialog fzf"
USEFULL_PACKAGES="pv colordiff mbuffer silversearcher-ag ncdu moreutils cpulimit"

apt-get update
apt-get -y upgrade
which locale-gen && locale-gen ru_RU.UTF-8 ru_UA.UTF-8 uk_UA.UTF-8
apt-get -y install git-core

apt-get -y install $BASE_PACKAGES

# optional usefull packages
# install packages sequentally because some of them can absent in some distributives
OPTIONAL_PKGS='exa bat'
for pkg in ${OPTIONAL_PKGS}; do
  apt-get install -y $pkg
done
apt-get clean

if [ "$user" != root ]; then
  echo "$user ALL=NOPASSWD: ALL" >>/etc/sudoers
else
  echo "vlad ALL=NOPASSWD: ALL" >>/etc/sudoers
fi

sed -i 's/^VCS=.*$/VCS=git/' /etc/etckeeper/etckeeper.conf
cd /etc
etckeeper init && etckeeper commit "initial" || echo "etckeeper fail"

if [ `id -u` = 0 ]; then
  git config --global user.email root@`hostname`  || true
  git config --global user.name root || true
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

# git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install



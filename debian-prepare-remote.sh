#!/bin/sh -e


host=$1

echo $host | grep "@" || host=root@${host}

SSH_KEY="`cat ~/.ssh/vlad2_rsa.pub`"

opts="-o StrictHostKeyChecking=no"

ssh ${opts} ${host} 'bash -c "which git >/dev/null || (sudo="`which sudo`"; $sudo apt-get update; $sudo apt-get install  -y git sudo);
						[ -d ~/bin ] && (cd ~/bin; git pull) || git clone https://github.com/slayer/bin.git ~/bin;
						[ -x ~/bin/debian-install-base-packages.sh ] && sudo ~/bin/debian-install-base-packages.sh ;
						mkdir -p ~/.ssh;
						grep '\'${SSH_KEY}\'' ~/.ssh/authorized_keys  || echo '\'$SSH_KEY\'' >>~/.ssh/authorized_keys;
						[ -d ~/bin ] && ~/bin/install-dotfiles.sh ;
						"'

reset

# [ -d ~/dotfiles ] && ( cd ~/dotfiles; git pull ) || git clone https://github.com/slayer/dotfiles.git ~/dotfiles

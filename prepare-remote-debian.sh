#!/bin/sh -e


host=$1

echo $host | grep "@" || host=root@${host}

SSH_KEY="`cat ~/.ssh/vlad_rsa.pub`"

echo "SSH_KEY: ${SSH_KEY}"

ssh ${host} 'bash -xc "which git >/dev/null || sudo apt-get install  -y git;
						[ -d ~/bin ] && (cd ~/bin; git pull) || git clone https://github.com/slayer/bin.git ~/bin;
						mkdir -p ~/.ssh;
						grep '\'${SSH_KEY}\'' ~/.ssh/authorized_keys  || echo '\'$SSH_KEY\'' >>~/.ssh/authorized_keys;
						[ -d ~/bin ] && ~/bin/install-dotfiles.sh ;

						"'

reset

# [ -d ~/dotfiles ] && ( cd ~/dotfiles; git pull ) || git clone https://github.com/slayer/dotfiles.git ~/dotfiles

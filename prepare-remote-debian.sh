#!/bin/sh -e


host=$1

ssh root@${host} "apt-get install  -y git &&
						git clone https://github.com/slayer/bin.git ~/bin;
						git clone https://github.com/slayer/dotfiles.git ~/dotfiles &&
							cd ~/dotfiles && git checkout -b dfm origin/dfm && ~/dotfiles/dfm;
						git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
						"

#!/bin/sh

which git >/dev/null || apt-get install -y git

[ -d ~/bin ] && (cd ~/bin && git pull) || git clone https://github.com/slayer/bin.git ~/bin
git clone https://github.com/slayer/dotfiles.git ~/dotfiles && cd ~/dotfiles && ~/dotfiles/dfm
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
which vim && vim -c "BundleInstall"

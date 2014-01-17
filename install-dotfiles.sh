#!/bin/sh

which git >/dev/null || apt-get install -y git

[ -d ~/bin ] || git clone https://github.com/slayer/bin.git ~/bin
git clone https://github.com/slayer/dotfiles.git ~/dotfiles && cd ~/dotfiles && git checkout -b dfm origin/dfm && ~/dotfiles/dfm
git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle

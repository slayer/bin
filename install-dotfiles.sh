#!/bin/bash

if [ ! -x `which git` ]; then
  sudo apt-get update
  sudo apt-get install -y git
fi

[ -d ~/bin ] && (cd ~/bin && git pull) || git clone https://github.com/slayer/bin.git ~/bin
if [ -d ~/dotfiles ]; then
  pushd ~/dotfiles && git pull; popd
else
  git clone https://github.com/slayer/dotfiles.git ~/dotfiles && cd ~/dotfiles && ~/dotfiles/dfm
fi

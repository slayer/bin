#!/bin/sh

apt-get update
which git >/dev/null || apt-get install -y git

[ -d ~/bin ] && (cd ~/bin && git pull) || git clone https://github.com/slayer/bin.git ~/bin
if [ -d ~/dotfiles ]; then
  pushd ~/dotfiles && git pull; popd
else
  git clone https://github.com/slayer/dotfiles.git ~/dotfiles && cd ~/dotfiles && ~/dotfiles/dfm
fi

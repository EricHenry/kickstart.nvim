#!/bin/bash

stable=false
while getopts s opt; do
  case $opt in
    s) stable=true;;
  esac
done

git clone https://github.com/neovim/neovim.git ~/opt/neovim

sudo rm /usr/local/bin/nvim
sudo rm -r /usr/local/share/nvim/

cd ~/opt/neovim

# if -s was specified when running, then checkout the stable branch
if [ $stable ]; then
  git checkout stable
fi

make CMAKE_BUILD_TYPE=Release

sudo make install

sudo rm -rf ~/opt/neovim

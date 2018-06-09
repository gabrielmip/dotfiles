#!/bin/bash

aptinstall="sudo apt install -y"
aptupdate="sudo apt update"
aptrepo="sudo add-apt-repository"
function debinstall {
  sudo dpkg -i $1
  aptinstall -f
  sudo dpkg -i
}

aptupdate
aptinstall build-essential curl wget unzip

# ZSH
aptinstall zsh git-core
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh
chsh -s `which zsh`
ln -s config/zsh/.zshrc ~/.zshrc

# HYPER
wget -O hyperjs.deb https://releases.hyper.is/download/deb
debinstall hyperjs.deb
rm hyperjs.deb
ln -s config/hyperjs/.hyper.js ~/.hyper.js

# ALBERT
aptrepo ppa:nilarimogard/webupd8
aptupdate
aptinstall albert
ln -s config/albert/albert.conf ~/.config/albert/albert.conf

# VIM
aptinstall neovim



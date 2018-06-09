#!/bin/bash

WORKDIR=$(pwd)

aptinstall="sudo apt install -y"
aptupdate="sudo apt update"
aptrepo="sudo add-apt-repository"
function debinstall {
  echo $1
  sudo dpkg -i $1
  sudo apt-get install -f
}

function rmlink {
  rm $2
  ln -s $1 $2 
}

$aptupdate
$aptinstall build-essential curl wget unzip locate

# HYPER
wget -O hyperjs.deb https://releases.hyper.is/download/deb
debinstall hyperjs.deb
rm hyperjs.deb
rmlink $WORKDIR/config/hyperjs/.hyper.js ~/.hyper.js

# ALBERT
$aptrepo ppa:nilarimogard/webupd8
$aptupdate
$aptinstall albert
rmlink $WORKDIR/config/albert/albert.conf ~/.config/albert/albert.conf

# VIM
$aptinstall neovim
mkdir -p ~/.config/nvim
rmlink $WORKDIR/config/vim/color ~/.config/nvim/color
rmlink $WORKDIR/config/vim/.vimrc ~/.config/nvim/init.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
vim +BundleInstall +qall

# ZSH
$aptinstall zsh git-core
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s $(which zsh)
rmlink $WORKDIR/config/zsh/.zshrc ~/.zshrc



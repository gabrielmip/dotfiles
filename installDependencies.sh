#!/bin/bash

function debinstall {
  echo $1
  sudo dpkg -i $1
  sudo apt-get install -f
}

function rmlink {
  rm $2
  ln -s $1 $2 
}

function log {
  printf "\n\n\n"
  echo \[$1\]
}

aptinstall="sudo apt install -y"
aptupdate="sudo apt update"
aptrepo="sudo add-apt-repository"

$aptupdate
$aptinstall build-essential curl wget unzip locate

log "HYPER"
wget -O hyperjs.deb https://releases.hyper.is/download/deb
debinstall hyperjs.deb
rm hyperjs.deb
rmlink $PWD/config/hyperjs/.hyper.js ~/.hyper.js

log "ALBERT"
$aptrepo ppa:nilarimogard/webupd8
$aptupdate
$aptinstall albert
rmlink $PWD/config/albert/albert.conf ~/.config/albert/albert.conf

log "VIM"
$aptinstall neovim
mkdir -p ~/.config/nvim
rmlink $PWD/config/vim/colors ~/.config/nvim/colors
rmlink $PWD/config/vim/.vimrc ~/.config/nvim/init.vim
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
vim +BundleInstall +qall

log "ZSH"
$aptinstall zsh git-core
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s $(which zsh)
rmlink $PWD/config/zsh/.zshrc ~/.zshrc

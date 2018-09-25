#!/bin/bash

function debinstall {
  echo $1
  sudo dpkg -i $1
  sudo apt-get install -f
}

function rmlink {
  rm -R $2
  ln -s $1 $2 
}

function log {
  printf "\n\n\n"
  echo \[$1\]
}

aptinstall="sudo apt install -y"
aptupdate="sudo apt update"
aptupdate="sudo apt upgrade"
aptrepo="sudo add-apt-repository"
ZSH_PLUGINS="${HOME}/.config/zsh_plugins"
CONFIGS_FOLDER="${PWD}"


$aptupdate
$aptupgrade
$aptinstall build-essential curl wget unzip locate
$aptinstall python3-venv python-dev python3-dev cmake
$aptinstall meld wdiff ctags

log "KONSOLE"
$aptinstall konsole
mkdir -p ~/.local/share/konsole
mkdir -p ~/.config
rmlink $PWD/konsole/Gabriel.profile ~/.local/share/konsole/Gabriel.profile
rmlink $PWD/konsole/Breeze.colorscheme ~/.local/share/konsole/Breeze.colorscheme
rmlink $PWD/konsole/konsolerc ~/.config/konsolerc
rmlink $PWD/fonts ~/.fonts
fc-cache -f -v

log "TERMINATOR"
$aptrepo ppa:gnome-terminator 
$aptupdate
$aptinstall terminator
rmlink $PWD/terminator/config ~/.config/terminator/config

log "ALBERT"
sudo sh -c "echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_18.04/ /' > /etc/apt/sources.list.d/home:manuelschneid3r.list"
wget -nv https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_18.04/Release.key -O Release.key
sudo apt-key add - < Release.key
rm Release.key
$aptupdate
$aptinstall albert
rmlink $PWD/albert/albert.conf ~/.config/albert/albert.conf

log "VIM"
$aptinstall neovim
mkdir -p ~/.config/nvim
rmlink $PWD/vim/init.vim ~/.config/nvim/init.vim
rmlink $PWD/vim/mappings.vim ~/.config/nvim/mappings.vim
rmlink $PWD/vim/plugins.vim ~/.config/nvim/plugins.vim
rmlink $PWD/vim/colors ~/.config/nvim/
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
vim +BundleInstall +qall
cd ~/.config/nvim/bundle/youcompleteme
./install.py
cd $CONFIGS_FOLDER

log "ZSH"
$aptinstall zsh git-core
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s $(which zsh)
rmlink $PWD/zsh/.zshrc ~/.zshrc

log "ZSH SYNTAX HIGHLIGHTING"
mkdir $ZSH_PLUGINS/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting/

log "FZF"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

log "RIPGREP"
curl -LO https://github.com/BurntSushi/ripgrep/releases/download/0.9.0/ripgrep_0.9.0_amd64.deb
sudo dpkg -i ripgrep_0.9.0_amd64.deb
rm ripgrep_0.9.0_amd64.deb

log "VS CODE"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
$aptupdate
$aptinstall code fonts-firacode
rmlink $PWD/Code/User ~/.config/Code/

log "CHROME"
$aptinstall libxss1 libappindicator1 libindicator7
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
debinstall google-chrome*.deb
rm google-chrome*

log "DOCKER"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$aptrepo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) test"
$aptupdate
$aptinstall docker-ce docker-compose
sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker


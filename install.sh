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
ZSH_PLUGINS="${HOME}/.config/zsh_plugins"

$aptupdate
$aptinstall build-essential curl wget unzip locate python3-venv

log "TERMINATOR"
$aptrepo ppa:gnome-terminator 
$aptupdate
$aptinstall terminator
rmlink $PWD/config/terminator/config ~/.config/terminator/config

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

log "ZSH SYNTAX HIGHLIGHTING"
mkdir $ZSH_PLUGINS/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting/
echo "source ${ZSH_PLUGINS}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

log "FZF"
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

log "VS CODE"
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
$aptupdate
$aptinstall code fonts-firacode

# deve ser o último
log "DOCKER"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$aptrepo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) test"
$aptupdate
$aptinstall docker-ce
sudo usermod -aG docker ${USER}
su - ${USER}

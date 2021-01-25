#!/bin/bash

function rmlink {
  ln -sfn $1 $2
}

function log {
  printf "\n\n\n"
  echo \[$1\]
}

CONFIGS_FOLDER="${PWD}"
ZSH_PLUGINS="${HOME}/.config/zsh_plugins"

sudo pacman -Sy --needed --noconfirm --quiet --noprogressbar yay

yay -Sy --needed --noconfirm --quiet --noprogressbar \
    neovim \
    zsh \
    zsh-completions \
    ranger \
    bat \
    fzf \
    fzf-extras \
    ripgrep \
    ctags \
    screen \
    docker \
    visual-studio-code-bin \
    dropbox \
    ttf-firacode


log "VIM"
mkdir -p ~/.config/nvim
rmlink $PWD/vim/init.vim ~/.config/nvim/init.vim
rmlink $PWD/vim/mappings.vim ~/.config/nvim/mappings.vim
rmlink $PWD/vim/plugins.vim ~/.config/nvim/plugins.vim
rmlink $PWD/vim/colors ~/.config/nvim/colors
if [ ! -e ~/.config/nvim/bundle/Vundle.vim ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
fi
nvim +BundleInstall +qall


log "VS CODE"
mkdir -p ~/.config/Code
rmlink $PWD/Code/User ~/.config/Code/



log "ZSH"
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi
rmlink $PWD/zsh/.zshrc ~/.zshrc
sudo chsh -s $(which zsh)
if [ ! -d $ZSH_PLUGINS/zsh-syntax-highlighting ]; then
  mkdir -p $ZSH_PLUGINS/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting/
fi


log "DROPBOX"
dropbox # it opens the browser to log in and etc

log "DOCKER"
sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker

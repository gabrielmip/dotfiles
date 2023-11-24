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

sudo pacman -Sy --needed --noconfirm --quiet --noprogressbar yay base-devel

yay -Sy --needed --noconfirm --quiet --noprogressbar \
  neovim \
  xclip \
  konsole \
  ttf-twemoji \
  zsh \
  zsh-completions \
  zsh-theme-powerlevel10k-git \
  ranger \
  bat \
  tldr \
  fzf \
  fzf-extras \
  ripgrep \
  ctags \
  screen \
  docker \
  meld \
  gimp \
  inkscape \
  gwenview \
  foliate \
  visual-studio-code-bin \
  ttf-firacode \
  i3-gaps \
  picom \
  xss-lock \
  i3lock \
  nm-applet \
  feh \
  pasystray \
  pavucontrol \
  dunst


log "VIM"
mkdir -p ~/.config/nvim
rmlink $PWD/vim/init.vim ~/.config/nvim/init.vim
rmlink $PWD/vim/plugins.vim ~/.config/nvim/plugins.vim
rmlink $PWD/vim/colors ~/.config/nvim/colors
rmlink $PWD/vim/autoload ~/.config/nvim/autoload
rmlink $PWD/vim/plugin ~/.config/nvim/plugin
rmlink $PWD/vim/snippets ~/.config/nvim/snippets
yay -S --noconfirm --quiet --noprogressbar pgformatter
nvim +PlugInstall +qall


log "VS CODE"
mkdir -p ~/.config/Code
rmlink $PWD/Code/User ~/.config/Code/


log "PICOM"
rmlink $PWD/picom/picom.conf ~/.config/picom.conf


log "I3"
mkdir -p ~/.config/i3
rmlink $PWD/i3/config ~/.config/i3/config
sudo cp $PWD/xsessions/plasma-i3.desktop /usr/share/xsessions/plasma-i3.desktop


log "ZSH"
if [ ! -d ~/.oh-my-zsh ]; then
  sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
fi
rmlink $PWD/zsh/zshrc ~/.zshrc
sudo chsh -s $(which zsh)
if [ ! -d $ZSH_PLUGINS/zsh-syntax-highlighting ]; then
  mkdir -p $ZSH_PLUGINS/zsh-syntax-highlighting
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting/
fi

log "DOCKER"
sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker

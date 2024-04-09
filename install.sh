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
  jq \
  unzip \
  konsole \
  ttf-twemoji \
  zsh \
  zsh-completions \
  zsh-theme-powerlevel10k-git \
  ranger \
  bat \
  glow \
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
  spectacle \
  postman-bin \
  spotify \
  zoom \
  chromium \
  git-standup-git \
  dbeaver \
  nvm \
  visual-studio-code-bin \
  ttf-firacode \
  python-pipx \
  nemo \
  klipper \
  blueman \
  i3-gaps \
  i3status \
  picom \
  arandr \
  xss-lock \
  i3lock \
  brightnessctl \
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
nvim +PlugInstall +qall


log "VIM LINTERS AND FORMATTERS"
pipx install black pylint
npm install --global eslint
npm install --global prettier
yay -Sy --needed --noconfirm --quiet --noprogressbar clj-kondo-bin joker-bin


log "VS CODE"
mkdir -p ~/.config/Code
rmlink $PWD/Code/User ~/.config/Code/


log "PICOM"
rmlink $PWD/picom/picom.conf ~/.config/picom.conf


log "GNOME POMODORO"
wget https://aur.archlinux.org/cgit/aur.git/snapshot/gnome-shell-pomodoro.tar.gz
tar -xvf gnome-shell-pomodoro.tar.gz && cd gnome-shell-pomodoro
makepkg -s
makepkg -i


log "I3 GNOME POMODORO"
pipx install i3-gnome-pomodoro


log "I3"
mkdir -p ~/.config/i3
rmlink $PWD/i3/config ~/.config/i3/config
rmlink $PWD/i3/exit.sh ~/.config/i3/exit.sh


log "BAT"
mkdir -p ~/.config/bat
rmlink $PWD/bat/config ~/.config/bat/config


log "GLOW"
mkdir -p ~/.config/glow
rmlink $PWD/glow/glow.yml ~/.config/glow/glow.yml


log "DUNST"
mkdir -p ~/.config/dunst
rmlink $PWD/dunst/dunstrc ~/.config/dunst/dunstrc


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

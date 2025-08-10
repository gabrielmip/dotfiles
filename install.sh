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

sudo pacman -Syu --needed --noconfirm --quiet --noprogressbar yay base-devel

sudo pacman -S \
  neovim \
  xclip \
  jq \
  unzip \
  konsole \
  zsh \
  zsh-completions \
  ranger \
  bat \
  glow \
  tldr \
  fzf \
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
  chromium \
  nvm \
  dbeaver \
  python-pipx \
  klipper \
  blueman \
  i3-gaps \
  i3status \
  picom \
  arandr \
  xss-lock \
  i3lock \
  brightnessctl \
  feh \
  pasystray \
  pavucontrol \
  playerctl \
  dunst \
  noto-fonts-emoji \
  networkmanager \
  network-manager-applet \
  ttf-fira-code

yay -Syu --needed --noconfirm --quiet --noprogressbar \
  zsh-theme-powerlevel10k-git

# ver se dá para forkar para poder instalar na mão com segurança
# git-standup-git
# mictray
# spotify
# gnome-shell-pomodoro / i3-gnome-pomodoro

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


log "I3"
mkdir -p ~/.config/i3
rmlink $PWD/i3/config ~/.config/i3/config
rmlink $PWD/i3/exit.sh ~/.config/i3/exit.sh
rmlink $PWD/dmenu/open_ipython ~/.local/bin/open_ipython


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

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
  neovim-nightly-bin \ # nightly until 0.5 comes
  xclip \
  konsole \
  zsh \
  zsh-completions \
  ranger \ # terminal file browser with vim-like shortcuts
  bat \ # alternative to cat
  fzf \
  fzf-extras \
  ripgrep \
  ctags \ # for vim tags
  screen \
  docker \
  meld \ # difftool
  gimp \
  inkscape \
  gwenview \ # simpler image edition/preview
  visual-studio-code-bin \
  dropbox \
  ttf-firacode \
  i3-gaps \ # window manager
  feh # set background images


log "VIM"
# nvim autocomplete and language server things
# I might have to install pip, but I am not sure
pip install --user msgpack neovim pynvim 'python-language-server[all]' pyls-mypy
yay -Sy --noconfirm yarn clojure-lsp-bin
yarn global add \
  typescript \
  typescript-language-server \
  vscode-css-languageserver-bin \
  vscode-json-languageserver \
  vscode-html-languageserver-bin \
  svelte-language-server \
  vim-language-server \
  bash-language-server

# configs and plugin install
mkdir -p ~/.config/nvim
rmlink $PWD/vim/init.vim ~/.config/nvim/init.vim
rmlink $PWD/vim/mappings.vim ~/.config/nvim/mappings.vim
rmlink $PWD/vim/plugins.vim ~/.config/nvim/plugins.vim
rmlink $PWD/vim/colors ~/.config/nvim/colors
rmlink $PWD/vim/autoload ~/.config/nvim/autoload
if [ ! -e ~/.config/nvim/bundle/Vundle.vim ]; then
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
fi
nvim +BundleInstall +qall


log "VS CODE"
mkdir -p ~/.config/Code
rmlink $PWD/Code/User ~/.config/Code/


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


log "DROPBOX"
dropbox # it opens the browser to log in and etc

log "DOCKER"
sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker

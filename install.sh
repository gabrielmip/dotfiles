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

sudo yay -Sy --needed --noconfirm --quiet --noprogressbar \
    neovim \
    konsole \
    zsh \
    zsh-completions \
    fzf \
    ripgrep \
    emacs \
    chromium \
    ctags \
    screen \
    nautilus \
    rlwrap \
    mysql \
    meld \
    albert \
    ttf-font-awesome-4 \
    visual-studio-code-bin \
    feh \
    scrot \
    i3-gaps \
    i3lock \
    i3status \
    ttf-hack \
    playerctl \
    rofi \
    compton


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
cd ~/.config/nvim/bundle/YouCompleteMe
python3 install.py --all
cd $CONFIGS_FOLDER


log "VS CODE"
mkdir -p ~/.config/Code
rmlink $PWD/Code/User ~/.config/Code/


log "SPACEMACS"
if [ ! -d ~/.emacs.d ]; then
  git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d
fi
rmlink $PWD/spacemacs/spacemacs ~/.spacemacs


log "i3-gaps"
mkdir -p ~/.config/compton
rmlink $PWD/i3/config ~/.config/i3/config
rmlink $PWD/i3status/config ~/.config/i3status/config
rmlink $PWD/compton/compton.conf ~/.config/compton/compton.conf


log "POLYBAR"
rmlink $PWD/polybar ~/.config/polybar


log "KONSOLE"
mkdir -p ~/.local/share/konsole
mkdir -p ~/.config
rmlink $PWD/konsole/Gabriel.profile ~/.local/share/konsole/Gabriel.profile
rmlink $PWD/konsole/One\ Dark.colorscheme ~/.local/share/konsole/One\ Dark.colorscheme
rmlink $PWD/konsole/konsolerc ~/.config/konsolerc
rm -rf ~/.fonts
rmlink $PWD/fonts ~/.fonts
fc-cache -f -v


log "ALBERT"
mkdir -p ~/.config/albert
rmlink $PWD/albert/albert.conf ~/.config/albert/albert.conf


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


log "DOCKER"
sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker

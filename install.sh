
function rmlink {
  if [[ -e $2 ]]; then
    rm -R $2
  fi
  ln -s $1 $2 
}

function log {
  printf "\n\n\n"
  echo \[$1\]
}

CONFIGS_FOLDER="${PWD}"
ZSH_PLUGINS="${HOME}/.config/zsh_plugins"

sudo pacman -Sy --needed --noconfirm --quiet --noprogressbar \
    yay \
    neovim \
    konsole \
    zsh \
    zsh-completions \
    fzf \
    ripgrep \
    emacs \
    chromium \
    ctags \
    meld


yay -S --needed --noconfirm --quiet --noprogressbar \
    albert \
    oh-my-zsh-git \
    visual-studio-code-bin


log "VIM"
mkdir -p ~/.config/nvim
rmlink $PWD/vim/init.vim ~/.config/nvim/init.vim
rmlink $PWD/vim/mappings.vim ~/.config/nvim/mappings.vim
rmlink $PWD/vim/plugins.vim ~/.config/nvim/plugins.vim
rmlink $PWD/vim/colors ~/.config/nvim/colors
git clone https://github.com/VundleVim/Vundle.vim.git ~/.config/nvim/bundle/Vundle.vim
nvim +BundleInstall +qall
cd ~/.config/nvim/bundle/youcompleteme
./install.py
cd $CONFIGS_FOLDER


log "KONSOLE"
mkdir -p ~/.local/share/konsole
mkdir -p ~/.config
rmlink $PWD/konsole/Gabriel.profile ~/.local/share/konsole/Gabriel.profile
rmlink $PWD/konsole/Breeze.colorscheme ~/.local/share/konsole/Breeze.colorscheme
rmlink $PWD/konsole/konsolerc ~/.config/konsolerc
rmlink $PWD/fonts ~/.fonts
fc-cache -f -v


log "ALBERT"
rmlink $PWD/albert/albert.conf ~/.config/albert/albert.conf


log "ZSH"
curl -L http://install.ohmyz.sh | sh
rmlink $PWD/zsh/.zshrc ~/.zshrc
chsh -s $(which zsh)
mkdir -p $ZSH_PLUGINS/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_PLUGINS/zsh-syntax-highlighting/


log "VS CODE"
rmlink $PWD/Code/User ~/.config/Code/
log "DOCKER"
sudo groupadd docker
sudo gpasswd -a $USER docker
newgrp docker

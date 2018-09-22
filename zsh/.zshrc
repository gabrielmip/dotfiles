
HOME=/home/gabriel
export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="muse" # my other favorites: bira, mh
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(git brew sudo docker-compose)
source $ZSH/oh-my-zsh.sh

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

alias sr="screen -r"
alias sS="screen -S"
alias ap="ansible-playbook"
alias start-climas="cd ~/waycarbon/build-scripts/dockerfiles && docker-compose -f docker-compose-buildserver.yml up"
alias gpoh="git push origin HEAD"
alias open=xdg-open
alias mysql="rlwrap mysql"
alias mongo="rlwrap mongo"
alias scheme="rlwrap scheme"

export PATH="${HOME}/mongo/bin"
export PATH="${PATH}:/usr/local/opt/php@7.0/bin"
export PATH="${PATH}:/usr/local/opt/php@7.0/sbin"
export PATH="${PATH}:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="${PATH}:/Library/TeX/Distributions/Programs/texbin"
export PATH="${PATH}:/usr/local/opt/icu4c/bin:/usr/local/opt/icu4c/sbin"
export PATH="${PATH}:${HOME}/.cargo/bin"
export PATH="${PATH}:${HOME}/Library/Python/2.7/lib/python/site-packages"
export PATH="${PATH}:/usr/local/lib/python2.7/site-packages"
export PATH="${PATH}:/usr/local/opt/mongodb@3.2/bin"
export PATH="${PATH}:${HOME}/.local/bin"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

mkcdir () {
  mkdir -p -- "$1" && cd -P -- "$1"
}

getin () {
  docker exec -it climas-$1 bash
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fpath=($fpath "${HOME}/.zfunctions")
FZF_CTRL_T_COMMAND="rg --files --no-messages --hidden --glob '!.git/'"

setxkbmap -option "caps:escape"

source /home/gabriel/.config/zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HOME=/home/gabriel

export ZSH="/home/gabriel/.oh-my-zsh"

ZSH_THEME="mortalscumbag" # my other favorites: bira, mh, muse
CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
plugins=(git sudo docker-compose)

source $ZSH/oh-my-zsh.sh

alias sr="screen -r"
alias sS="screen -S"
alias ap="ansible-playbook"
alias gpoh="git push origin HEAD"
alias open=xdg-open
alias vim="nvim"
alias containers='docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"'
alias compose="docker-compose"

export PATH="${PATH}:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="${PATH}:/Library/TeX/Distributions/Programs/texbin"
export PATH="${PATH}:${HOME}/.local/bin"
export PATH="${PATH}:${HOME}/.yarn/bin"
export PATH="${PATH}:/usr/local/apps/liquibase"

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk
export ANDROID_HOME="${HOME}/Android/Sdk"
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/platform-tools
export HD=/run/media/gabriel/Geral

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

mkcdir () {
  mkdir -p -- "$1" && cd -P -- "$1"
}

setupstream () {
  git branch --set-upstream-to=origin/$(git_current_branch) $(git_current_branch)
}

regs () {
  CURRENT=$PWD
  cd ~/Dropbox/Registros
  vim
  cd $CURRENT
  unset CURRENT
}

FZF_CTRL_T_COMMAND="rg --files --no-messages --hidden --glob '!.git/'"

setxkbmap -option "caps:escape"

source /home/gabriel/.config/zsh_plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/fzf/completion.zsh
source /usr/share/fzf/key-bindings.zsh

if [[ -e $HOME/.alude-aliases ]]
then
  source $HOME/.alude-aliases
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

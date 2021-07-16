# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=5000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/m00n/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache

export ALCRO_BROWSER_PATH=/usr/bin/brave

alias cleanup_packages='(set -x; sudo pacman -R $(pacman -Qdtq))'
alias ls='ls --color=auto'

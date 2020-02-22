#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll="ls -l --color=auto"
alias lal="ls -al --color=auto"

alias fzpacman="pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias fzyay="yay -Slq | fzf -m --preview 'yay -Si {1}'| xargs -ro yay -S"

PS1='[\u@\h \W$(parse_git_branch)] λ '

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

alias diff="diff-so-fancy"
alias cat="bat"
alias find="fd"

export HISTCONTROL=ignoredups
shopt -s autocd

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ ~ \1/'
}

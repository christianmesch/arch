#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll="ls -l --color=auto"
alias lal="ls -al --color=auto"
#PS1='[\u@\h \W]\$ '
PS1='[\u@\h \W$(parse_git_branch)] λ '

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

alias diff="diff-so-fancy"
alias cat="bat"
alias find="fd"

export HISTCONTROL=ignoredups
shopt -s autocd

parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ ~ \1/'
}

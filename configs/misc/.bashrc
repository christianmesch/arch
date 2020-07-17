#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll="ls -l --color=auto"
alias lal="ls -al --color=auto"

alias fpacman="pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias fyay="yay -Slq | fzf -m --preview 'yay -Si {1}'| xargs -ro yay -S"

PS1='\[\033[38;5;1m\]$(last_command)\[$(tput sgr0)\]\[\033[38;5;3m\]\w\[$(tput sgr0)\]\[\033[38;5;6m\]$(parse_git_branch)\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;2m\]λ\[$(tput sgr0)\] \[$(tput sgr0)\]'

parse_git_branch() {
	local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    if ! [ -z "$branch" ]; then
        echo " ($branch)"
    fi
}

last_command() {
    if [[ $? -ne 0 ]]; then echo '> '; fi
}

bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

#alias diff="diff-so-fancy"
alias cat="bat"

export HISTCONTROL=ignoredups
shopt -s autocd

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    eval "$(<"$XDG_RUNTIME_DIR/ssh-agent.env")" 2>&1 >/dev/null
fi

source /usr/share/fzf/key-bindings.bash
source /usr/share/fzf/completion.bash

# Use bash-completion, if available
[[ $PS1 && -f /usr/share/bash-completion/bash_completion ]] && \
    . /usr/share/bash-completion/bash_completion

# tabtab source for packages
# uninstall by removing these lines
[ -f ~/.config/tabtab/__tabtab.bash ] && . ~/.config/tabtab/__tabtab.bash || true

# aws completion
[ -f /usr/bin/aws_completer ] && complete -C '/usr/bin/aws_completer' aws || true

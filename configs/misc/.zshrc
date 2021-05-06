# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/mesch/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(gitfast docker aws fzf ssh-agent sudo zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
alias ls='exa --color=auto --group-directories-first'
alias ll="exa -l --color=auto --group-directories-first"
alias lal="exa -al --color=auto --group-directories-first"

alias fpacman="pacman -Slq | fzf -m --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S"
alias fyay="yay -Slq | fzf -m --preview 'yay -Si {1}'| xargs -ro yay -S"
alias fparu="paru -Slq | fzf -m --preview 'paru -Si {1}'| xargs -ro paru -S"

parse_git_dirty() {
  [[ -n "$(git status -s 2> /dev/null)" ]] && echo "*"
}

parse_git_branch() {
	local branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
    if ! [ -z "$branch" ]; then
        echo " ($branch$(parse_git_dirty))"
    fi
}

# aws-vault stuff
# Borrowed from https://github.com/mozilla/multi-account-containers/issues/365#issuecomment-527122371
awslogin() {
  FIREFOX="firefox"
  LOGIN_URL=$(aws-vault login --stdout "${1}")
  [[ $? != 0 ]] && echo "${LOGIN_URL}" && return
  ENCODED_URL="${LOGIN_URL//&/%26}"
  URI_HANDLER="ext+container:name=${1}&url=${ENCODED_URL}"
  "${FIREFOX}" "${URI_HANDLER}"
}

_fzf_complete_awslogin() {
  _fzf_complete --prompt="profile> " -- "$@" < <(
    aws-vault list --profiles | sort | uniq
  )
}

_fzf_complete_aws-vault() {
  _fzf_complete --prompt="profile> " -- "$@" < <(
    aws-vault list --profiles | sort | uniq
  )
}

# tmux stuff
tm() {
  if [ $# -lt 1 ]; then
    echo "No arguments provided. Usage:\ntm <session name>"
    return 1
  fi

  if tmux has-session -t $1; then
    tmux attach -t $1
  elif tmuxinator l | grep -qE "^$1$"; then
    echo "Starting tmuxinator project $1"
    tmuxinator s $1
  else
    echo "Creating new session $1"
    tmux new -s $1
  fi
}

_fzf_complete_tm() {
  _fzf_complete --prompt="sessions> " -- "$@" < <(
    TM_SESSIONS=`tmux ls | awk -F':' '{print $1}'`
    TMUXINATOR_PROFILES=`tmuxinator l | sed '1d'`
    echo "$TM_SESSIONS\n$TMUXINATOR_PROFILES" | sort | uniq
  )
}

if [ ! "$TMUX" = "" ]; then export TERM=tmux-256color; fi

# Prompt
PROMPT='%F{yellow}%~%F{cyan}$(parse_git_branch)%f %(?.%F{green}.%F{red})λ%f '
PROMPT2='> '

export EDITOR='vim'

# History
unsetopt sharehistory
setopt incappendhistorytime
# Added by serverless binary installer
export PATH="$HOME/.serverless/bin:$PATH"

# Source
source /usr/share/nvm/init-nvm.sh

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/__tabtab.zsh ]] && . ~/.config/tabtab/__tabtab.zsh || true

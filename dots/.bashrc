# Enable the subsequent settings only in interactive sessions
case $- in
*i*) ;;
*) return ;;
esac

export OSH='/home/mkonji/.oh-my-bash'
source /etc/bashrc

# This is where you put your hand rolled scripts (remember to chmod them)
PATH="$HOME/bin:$PATH"

OSH_THEME="font"

# Uncomment the following line to use case-sensitive completion.
# OMB_CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# OMB_HYPHEN_SENSITIVE="false"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_OSH_DAYS=30

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you don't want the repository to be considered dirty
# if there are untracked files.
# SCM_GIT_DISABLE_UNTRACKED_DIRTY="true"

# Uncomment the following line if you want to completely ignore the presence
# of untracked files in the repository.
# SCM_GIT_IGNORE_UNTRACKED="true"

# Uncomment the following line if you do not want OMB to overwrite the existing
# aliases by the default OMB aliases defined in lib/*.sh
# OMB_DEFAULT_ALIASES="check"

# Would you like to use another custom folder than $OSH/custom?
# OSH_CUSTOM=/path/to/new-custom-folder

# To disable the uses of "sudo" by oh-my-bash, please set "false" to
# this variable.  The default behavior for the empty value is "true".
OMB_USE_SUDO=true

# To enable/disable display of Python virtualenv and condaenv
# OMB_PROMPT_SHOW_PYTHON_VENV=true  # enable
# OMB_PROMPT_SHOW_PYTHON_VENV=false # disable

# Which completions would you like to load? (completions can be found in ~/.oh-my-bash/completions/*)
# Custom completions may be added to ~/.oh-my-bash/custom/completions/
completions=(
	git
	composer
	ssh
	docker
	go
	kubectl
	helm
	maven
	minikube
	pip
	pip3
	awscli
	makefile
	terraform
	oc
	defaults
)

# Custom aliases may be added to ~/.oh-my-bash/custom/aliases/
aliases=(
	general
)

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
plugins=(
	git
	bashmarks
)

# Which plugins would you like to conditionally load? (plugins can be found in ~/.oh-my-bash/plugins/*)
# Custom plugins may be added to ~/.oh-my-bash/custom/plugins/
# Example format:
#  if [ "$DISPLAY" ] || [ "$SSH" ]; then
#      plugins+=(tmux-autoattach)
#  fi

source "$OSH"/oh-my-bash.sh

# User configuration
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
	export EDITOR='vim'
else
	export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

alias sudo='doas'

alias nixrb='doas nixos-rebuild switch'
alias nixup='doas nixos-rebuild switch --upgrade-all'

alias ns='nix-shell -p'
alias md='mkdir -p'
alias c='clear'
alias e='exit'

alias ts='date -u +"%Y-%m-%dT%H:%M:%SZ"'

alias ls='eza -lg --icons --header --group-directories-first'
alias la='eza -lag --icons --header --group-directories-first'
alias lr='eza -lTg -L 2 --icons --header --group-directories-first'
alias lR='eza -lTg --icons --header --group-directories-first'
alias l='ls -CFlh'
alias lsd='ls -alF | grep /$'

alias localip='ip -brief -color addr'

# This is GOLD for finding out what is taking so much space on your drives!
alias diskspace="du -S | sort -n -r |more"

# Command line mplayer movie watching for the win.
alias mp="mplayer -fs"

# Show me the size (sorted) of only the folders in this directory
alias folders="find . -maxdepth 1 -type d -print | xargs du -sk | sort -rn"

# removes the need for cd.. cd.. cd.. QOL improvement
up() {
	local d=""
	limit=$1
	for ((i = 1; i <= limit; i++)); do
		d=$d/..
	done
	d=$(echo $d | sed 's/^\///')
	if [ -z "$d" ]; then
		d=..
	fi
	cd $d
}

bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

# vi mode
#set -o vi

# smart advanced completion
if [[ -f $HOME/local/bin/bash_completion ]]; then
	. $HOME/local/bin/bash_completion
fi

# doas completion
complete -cf doas

extract() { # extract files. Ignore files with improper extensions.
	local x
	ee() { # echo and execute
		echo "$@"
		$1 "$2"
	}
	for x in "$@"; do
		[[ -f $x ]] || continue
		case "$x" in
		*.tar.bz2 | *.tbz2) ee "tar xvjf" "$x" ;;
		*.tar.gz | *.tgz) ee "tar xvzf" "$x" ;;
		*.bz2) ee "bunzip2" "$x" ;;
		*.rar) ee "unrar x" "$x" ;;
		*.gz) ee "gunzip" "$x" ;;
		*.tar) ee "tar xvf" "$x" ;;
		*.zip) ee "unzip" "$x" ;;
		*.Z) ee "uncompress" "$x" ;;
		*.7z) ee "7z x" "$x" ;;
		esac
	done
}

export VISUAL=nvim

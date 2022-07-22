# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Non-interactive guard
case $- in
    *i*) ;;
      *) return;;
esac

### History configuration 
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

### Prompt configuration
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

USERNAME="\u"
HOSTNAME="\h"
WORKDIR="\W"
RESET="\[\033[0m"
RED="\[\033[00;31m\]"
RED_BOLD="\[\033[01;31m\]"
GREEN="\[\033[00;32m\]"
GREEN_BOLD="\[\033[01;32m\]"
YELLOW="\[\033[00;33m\]"
YELLOW_BOLD="\[\033[01;33m\]"
BLUE="\[\033[00;34m\]"
BLUE_BOLD="\[\033[01;34m\]"
WHITE="\[\033[00;37m\]"
WHITE_BOLD="\[\033[01;37m\]"

PS1="${GREEN_BOLD}┌ ${USERNAME}@${HOSTNAME}${BLUE_BOLD} ➜ ${WORKDIR} ${YELLOW_BOLD}\$(parse_git_branch)\n${GREEN_BOLD}└┄ ${RESET}"
PS2="${YELLOW_BOLD}➜ ${RESET}"

# Source aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Source functions
if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
fi

# Source programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Add paths
path_prepend() {
    # Only adds path if it exists and isn't already included in PATH
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1${PATH:+":$PATH"}"
    fi
}

path_append() {
    # Only adds path if it exists and isn't already included in PATH
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

path_prepend ~/.local/bin
path_prepend ~/bin

# Environment variables
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
export SSL_CERT_DIR=/etc/ssl/certs

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --glob '!.git''
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi

if type nvim &> /dev/null; then
    export VISUAL=nvim
else
    export VISUAL=vim
fi
export EDITOR="$VISUAL"

# General
alias q='exit'
alias c='clear'
alias h='history'

# These should probably be in the .bashrc
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Nice to have aliases
alias home='cd ~'
alias wiki='vim -c ":VimwikiIndex"'
alias todo='vim -c ":VimwikiIndex" -c ":VimwikiGoto Todo"'
alias open=xdg-open
alias reload='. ~/.bash_profile'

# This need some more customization (not sure what I want yet)
alias diskspace="du -S | sort -n -r | less -F"

# Navigation aliases
alias ..='cd ..'
alias ...='cd ..; cd ..'
alias ....='cd ..; cd ..; cd ..'

# Editor aliases
alias v='nvim'

# Ansible aliases
alias play='ansible-playbook'

# Git aliases
alias gst='git status'
alias gd='git diff'
alias gcb='git checkout -b'
alias gp='git push'
alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsu='git submodule update'
alias gsuir='git submodule update --init --recursive'

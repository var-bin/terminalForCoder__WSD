# .bashrc

# Source global definitions
if [[ -f /etc/bashrc ]]
then
  . /etc/bashrc
fi

source ~/git-completion.bash

# Making SSH_AUTH_SOCK work between detaches in tmux/screen
if [[ ! -z "$SSH_AUTH_SOCK" -a "$SSH_AUTH_SOCK" != "${HOME}/agent_sock" ]]
then
   unlink "${HOME}/agent_sock" 2>/dev/null
   ln -s "$SSH_AUTH_SOCK" "${HOME}/agent_sock"
   export SSH_AUTH_SOCK="${HOME}/agent_sock"
fi

# User specific aliases and functions
alias gst='git status'
alias gf='git fetch'
alias gm='git merge'
alias gd='git diff'
alias gb='git branch'
alias gbm='git branch --merged'
alias gcm='git commit -m'
alias gp='git push origin'
alias gbd='git branch -D'
alias gshorth='git log -p -2'
alias gch='git checkout'
alias grntds='./grunt deploySync'
alias grntd='./grunt deploy'
alias ghide='git stash'
alias gshow='git stash pop'
alias gsl='git stash list'
alias myps='ps aux | grep rybka'
alias gmom='git merge origin/master'
alias gad='git add'
alias grm='git rm'
alias showaliases='cat $HOME/.bashrc | grep alias'

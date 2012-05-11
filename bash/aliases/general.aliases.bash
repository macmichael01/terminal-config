#!/usr/bin/env bash

# GENERAL

# SUDO
alias _="sudo"
alias reload='source ~/.bashrc'

# LIST DIRECTORY
if [ "$(uname -s)" == "FreeBSD" ]; then
    alias ls="ls -F -G"
elif [ "$(uname -s)" == "Linux" ]; then
    alias ls="ls -F --color=auto"
else
    alias ls="ls -F"
fi
alias sl=ls         # Typo alias
alias la='ls -A'    # Show compact view horizontal.
alias l1='ls -1'    # Show compact view vertical.
alias l='ls -lhS'   # Show files, folders, & symlinks with readable filesize.
alias ll='ls -alh'  # Show files folders, symlinks, & hidden files with readable filesize.
alias lm="ls -lhrt" # Show files folders, symlinks, & hidden files with readable filesize ordered by last modified.

# CHANGE DIRECTORY
alias cd..='cd ..'       # Typo alias
alias ..='cd ..'         # Go up one directory
alias ...='cd ../..'     # Go up two directories
alias ....='cd ../../..' # Go up two directories
alias -- -="cd -"        # Go back

# MAKE OR REMOVE DIRECTORY
alias	md='mkdir -p'
alias	rd=rmdir

# DIRECTORY TREE
alias dtree='find . -type d | sed -e "s/[^-][^\/]*\//  |/g" -e "s/|\([^ ]\)/|-\1/"'
if [ ! -x "$(which tree 2> /dev/null)" ]
then
  alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
fi

# CLEAR
alias c='clear'
alias k='clear'
alias cls='clear'

# EXIT TERMINAL
alias q="exit"
alias :q='exit'
alias :wq='exit'
alias :q!='kill -9 $$'

# TAR
alias mktar='tar cvf'
alias untar='tar xvf'
alias vwtar='tar tvf'

# EDITORS
alias edit="$EDITOR"
alias pager="$PAGER"
alias irc="$IRC_CLIENT"
alias rb="ruby"
alias py="python"

# PING
alias ping='ping -c 5'   # Ping 5 times
alias ping6='ping6 -c 5' # Ping 5 times

# SSH
alias ssh='ssh -YC' # Use compression and blowfish

# HISTORY
alias h='history'            # Shortcut
alias hs='history | grep $1' # Search history
alias hc='history -c'        # Clear history

# DF
alias df='df -h' # Make df readable.

# TOP
if [ ! -x "$(which htop 2> /dev/null)" ]
then
  alias top='htop'
fi

# GSHUF
if [ ! -x "$(which gshuf 2> /dev/null)" ]
then
  alias shuf='gshuf'
fi

# TOTAL Lines of code.
alias loc="find . \( -iname '*.[ch]' -o -iname '*.php' -o -iname '*.pl' \) | xargs wc -l | sort -n"

# RANDOM String
alias random="strings /dev/urandom | grep -o '[[:alnum:]]' | head -n 30 | tr -d '\n'; echo"

# PIANOBAR found here: http://github.com/PromyLOPh/pianobar/
alias piano="pianobar"


function aliases-help() {
  echo "Generic Alias Usage"
  echo
  echo "  _        = sudo"
  echo "  reload   = source ~/.bashrc"
  echo "  sl       = ls"
  echo "  ls       = ls -G"
  echo "  ll       = ls -alh"
  echo "  la       = ls -AF"
  echo "  l1       = ls -1"
  echo "  lm       = ls -lhrt"
  echo "  l        = ls -lhS"
  echo "  c/k/cls  = clear"
  echo "  cd..     = cd .."
  echo "  ..       = cd .."
  echo "  ...      = cd ../.."
  echo "  -        = cd -"
  echo "  h        = history"
  echo "  hs       = history | grep $1"
  echo "  hc       = history -c"
  echo "  md       = mkdir -p"
  echo "  rd       = rmdir"
  echo "  ssh      = ssh -YC"
  echo "  editor   = $EDITOR"
  echo "  pager    = $PAGER"
  echo "  piano    = pianobar"
  echo "  q/:q/:wq = exit"
  echo "  :q!      = kill -9 $$"
  echo "  df       = df -h"
  echo "  irc      = $IRC_CLIENT"
  echo "  md       = mkdir -p"
  echo "  rd       = rmdir"
  echo "  rb       = ruby"
  echo "  py       = python"
  echo
}

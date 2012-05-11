#!/usr/bin/env bash

# append to bash_history if Terminal.app quits
shopt -s histappend

# history handling
#
# Erase duplicates
# Bash History
export HISTCONTROL="ignoredups"
export HISTCONTROL=erasedups

# resize history size
export HISTSIZE=5000

export AUTOFEATURE=true autotest

function rh {
  history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
}


# HISTORY
export HISTTIMEFORMAT='%F %T '

# Ignore specific commands. Use : as the seperator.
export HISTIGNORE="fg*"

# Don't put duplicate lines in the history.
# ... or force ignoredups and ignorespace.
HISTCONTROL=ignoredups:ignorespace

# Append to the history file, don't overwrite.
shopt -s histappend

# Set history length (0 prevents storing history)
HISTSIZE=1000
HISTFILESIZE=2000

# After each command, save and reload history
#export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

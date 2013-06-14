#!/usr/bin/env bash

# DOS to UNIX commands
alias copy='cp'
alias move='mv'
alias rename='rm'
alias del='rm'
alias deltree='rm -fr'
alias type='less'
alias print='lpr'
alias fc='diff'
alias scandisk='fsck'
alias ipconfig='ifconfig'
alias tracert='tracepath'
alias cls='clear'
alias help='man'

function dos-help() {
  echo "DOS Aliases Usage"
  echo
  echo " copy = cp"
  echo " move = mv"
  echo " rename = rm"
  echo " del = rm"
  echo " deltree = rm -fr"
  echo " type = less"
  echo " print = lpr"
  echo " fc = diff"
  echo " scandisk = fsck"
  echo " ipconfig = ifconfig"
  echo " tracert = tracepath"
  echo " cls = clear"
  echo " help = man"
  echo
}

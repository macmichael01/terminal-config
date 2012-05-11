#!/usr/bin/env bash

# TEXT.TXT-CLI

alias tls="$TODO ls"
alias ta="$TODO a"
alias trm="$TODO rm"
alias tdo="$TODO do"
alias tpri="$TODO pri"

t() {
  # about one thing todo
  # param if not set, display todo item
  # param 1: todo text
	if [[ "$*" == "" ]] ; then
	    cat ~/.t
	else
	    echo "$*" > ~/.t
	fi
}

todo-help() {
	echo
	echo "todo.txt-cli Custom Aliases Usage"
	echo
	echo " tls  = $TODO ls"
	echo " ta   = $TODO add"
	echo " trm  = $TODO rm"
	echo " tdo  = $TODO do"
	echo " tpri = $TODO pri"
	echo
}

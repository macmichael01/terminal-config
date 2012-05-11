#!/usr/bin/env bash

function add_ssh() {
  echo -en "\n\nHost $1\n  HostName $2\n  User $3\n  ServerAliveInterval 30\n  ServerAliveCountMax 120" >> ~/.ssh/config
}

function sshlist() {
  awk '$1 ~ /Host$/ { print $2 }' ~/.ssh/config
}


function cpkey {
	KEY="$HOME/.ssh/id_rsa.pub"
	KEY2="$HOME/.ssh/id_dsa.pub"

	if [ ! -f $KEY || ! -f $KEY2 ];then
		echo "SSH Key not found. Please create one using ssh-keygen."
		return
	fi

	if [ -z $1 ];then
		echo "Please specify user@example.com as the first switch to this script"
		return
	fi

  if [ -f $KEY ];then
    MYKEY=$KEY
  else
    MYKEY=$KEY2
  fi

	echo "Putting your public key on $1... "
	cat $MYKEY | ssh -q $1 "mkdir ~/.ssh 2>/dev/null; chmod 700 ~/.ssh; cat - >> ~/.ssh/authorized_keys; chmod 644 ~/.ssh/authorized_keys"
	echo "done!"
}

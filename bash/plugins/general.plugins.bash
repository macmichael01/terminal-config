#!/usr/bin/env bash

pickfrom() {
    # about picks random line from file
    # param 1: filename
    # example $ pickfrom /usr/share/dict/words
    local file=$1
    [ -z "$file" ] && reference $FUNCNAME && return
    length=$(cat $file | wc -l)
    n=$(expr $RANDOM \* $length \/ 32768 + 1)
    head -n $n $file | tail -1
}

pmdown() {
    # about preview markdown file in a browser
    # param 1: markdown file
    # example $ pmdown README.md
    if command -v markdown &>/dev/null
    then
      markdown $1 | browser
    else
      echo "You don't have a markdown command installed!"
    fi
}

lsgrep() {
    # about search through directory contents with grep
    ls | grep "$*"
}

pman() {
    # about view man documentation in Preview
    # param 1: man page to view
    # example $ pman bash
    man -t "${1}" | open -f -a $PREVIEW
}

pcurl() {
    # about download file and Preview it
    # param 1: download URL
    # example $ pcurl http://www.irs.gov/pub/irs-pdf/fw4.pdf
    curl "${1}" | open -f -a $PREVIEW
}

pri() {
    # about display information about Ruby classes, modules, or methods, in Preview
    # param 1: Ruby method, module, or class
    # example $ pri Array
    ri -T "${1}" | open -f -a $PREVIEW
}

quiet() {
	$* &> /dev/null &
}

banish-cookies() {
  # about redirect .adobe and .macromedia files to /dev/null
	rm -r ~/.macromedia ~/.adobe
	ln -s /dev/null ~/.adobe
	ln -s /dev/null ~/.macromedia
}

command_exists() {
    # about checks for existence of a command
    # param 1: command to check
    # example $ command_exists ls && echo 'exists'
    type "$1" &> /dev/null ;
}

# useful for administrators and configs
buf() {
    # about back up file with timestamp
    # param filename
    local filename=$1
    local filetime=$(date +%Y%m%d_%H%M%S)
    cp ${filename} ${filename}_${filetime}
}

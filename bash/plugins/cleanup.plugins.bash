#!/usr/bin/env bash

# Files and patterns.
export CLEANUP_FILES=( "~*" "*~" ".DS_Store" "._*" ".Spotlight-v100" "*.pyc" )

# Cleans up unwanted files from a directory.
function cleanup() {
  CLEANUP_PATH="."
  CLEANUP_FILE="/tmp/cleanup.out"
  CLEANUP_COMMAND="find $CLEANUP_PATH"
  CLEANUP_COMMAND_STR="$(printf " -or -name '%s'" ${CLEANUP_FILES[@]})"
  CLEANUP="$CLEANUP_COMMAND ${CLEANUP_COMMAND_STR:4}"
  CLEANUP_VERBOSE=0
  CLEANUP_CONFIRM=1
  OPTIND=1 # Reset
  while getopts "vi" opt; do
  case "$opt" in
    v)
      CLEANUP_VERBOSE=1
      ;;
    i)
      CLEANUP_CONFIRM=1
      ;;
    esac
  done
  shift $((OPTIND-1))
  if [ -z "$@" ]; then
    if [ -d "$@" ]; then
      CLEANUP_PATH="$@"
    fi
  fi
  if [ -e ${CLEANUP_FILE} ]; then
    rm ${CLEANUP_FILE}
  fi
  eval "$CLEANUP >> $CLEANUP_FILE"
  if [ $CLEANUP_VERBOSE -eq 1 ]; then
  if [ -s $CLEANUP_FILE ]; then
    echo -e "\n${echo_bold_blue}Files Found: ${echo_reset_color}\n"
    while read line
    do
      echo -e "${echo_cyan} $line${echo_reset_color}"
    done < "$CLEANUP_FILE"
  fi
  fi
  if [ ! -s $CLEANUP_FILE ]; then
    return
  fi
  if [ $CLEANUP_CONFIRM -eq 1 ]; then
    while true; do
        echo -en "\n${echo_bold_red}Cleanup Files? [Y/n]: ${echo_reset_color}"
        read yn
        case $yn in
            [Yy]* )
            CLEANUP_CONFIRM=0
            echo
            break
            ;;
            [Nn]* ) echo; return;;
        esac
    done
  fi

  if [ $CLEANUP_CONFIRM -eq 0 ]; then
    while read line
    do
      rm ${line}
    done < "$CLEANUP_FILE"
  fi
  rm "$CLEANUP_FILE"
}

# Verbose and Removal confirmation on by default.
alias cleanup="cleanup -vi"

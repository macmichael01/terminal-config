#!/usr/bin/env bash

# Directory stack navigation:
#
# Add to stack with: pu /path/to/directory
# Delete current dir from stack with: po
# Show stack with: d
# Jump to location by number.

# Show directory stack
alias d="dirs -v -l"

# Change to location in stack bu number
alias 1="pushd"
alias 2="pushd +2"
alias 3="pushd +3"
alias 4="pushd +4"
alias 5="pushd +5"
alias 6="pushd +6"
alias 7="pushd +7"
alias 8="pushd +8"
alias 9="pushd +9"

# Clone this location
alias pc="pushd \`pwd\`"

# Push new location
alias pu="pushd"

# Pop current location
alias po="popd"

function dirs-help() {
  echo "Directory Navigation Alias Usage"
  echo
  echo "Use the power of directory stacking to move"
  echo "between several locations with ease."
  echo
  echo "d	       : Show directory stack."
  echo "po	     : Remove current location from stack."
  echo "pc	     : Adds current location to stack."
  echo "pu <dir> : Adds given location to stack."
  echo "1	       : Change to stack location 1."
  echo "2	       : Change to stack location 2."
  echo "3	       : Change to stack location 3."
  echo "4	       : Change to stack location 4."
  echo "5	       : Change to stack location 5."
  echo "6	       : Change to stack location 6."
  echo "7	       : Change to stack location 7."
  echo "8	       : Change to stack location 8."
  echo "9	       : Change to stack location 9."
}


# ADD BOOKMARKing functionality
# usage:

# if doesn't exist, create it
if [ ! -f ~/.dirs ]; then
    touch ~/.dirs
else
    source ~/.dirs
fi

G () {
    # goes to distination dir otherwise , stay in the dir
    cd ${1:-$(pwd)} ;
}

S () {
    # SAVE a BOOKMARK
    sed "/$@/d" ~/.dirs > ~/.dirs1;
    \mv ~/.dirs1 ~/.dirs;
    echo "$@"=\"`pwd`\" >> ~/.dirs;
    source ~/.dirs ;
}

R () {
    # remove a BOOKMARK
    sed "/$@/d" ~/.dirs > ~/.dirs1;
    \mv ~/.dirs1 ~/.dirs;
}

alias L='cat ~/.dirs'
alias U='source ~/.dirs' # Update BOOKMARK stack

shopt -s cdable_vars     # set the bash option so that no '$' is required when using the above facility

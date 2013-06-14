#!/usr/bin/env bash

# PYTHON

if [ $(uname) = "Linux" ]
then
  alias http='python2 -m SimpleHTTPServer'
else
  alias http='python -m SimpleHTTPServer'
fi

# PYTHON
alias py="python"
alias bpy="bpython"
alias ipy="ipython"

# Find python file(s)
alias pyfindall='find . -name "*.py"'
alias pyfind='find . -name "$1.py"'

# Remove python compiled byte-code
alias pyclean='find . -type f -name "*.py[co]" -exec rm -f \{\} \;'

# Clean Whitespace
alias pywhitespace="find . -name '*.py' -exec sed -i {} -e 's/[ \t]*$//' ';'"

# Python SMTP Debug server
alias pysmtp='python -m smtpd -n -c DebuggingServer localhost:1025'

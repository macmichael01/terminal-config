#!/usr/bin/env bash

# PYTHON

if [ $(uname) = "Linux" ]
then
  alias http='python2 -m SimpleHTTPServer'
else
  alias http='python -m SimpleHTTPServer'
fi

# PYTHON
alias bpy="bpython"
alias ipy="ipython"
alias py="python"

# REMOVE .pyc
alias rmpyc='find . -name "*.pyc" -exec rm -fr {} \;'

# CLEANUP WHITESPACE
alias rmpyws="find . -name '*.py' -exec sed -i {} -e 's/[ \t]*$//' ';'"

# SMTP DEBUG SERVER.
alias pysmtp='python -m smtpd -n -c DebuggingServer localhost:1025'

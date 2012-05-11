#!/usr/bin/env bash

# Generate a password.
function genpasswd() {
        local l=$1
        [ "$l" == "" ] && l=20
        tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${l} | xargs
}

pass() {
    # about generates random password from dictionary words
    # param optional integer length
    # param if unset, defaults to 4
    # example $ pass
    # example $ pass 6
    local i pass length=${1:-4}
    pass=$(echo $(for i in $(eval echo "{1..$length}"); do pickfrom /usr/share/dict/words; done))
    echo "With spaces (easier to memorize): $pass"
    echo "Without (use this as the pass): $(echo $pass | tr -d ' ')"
}

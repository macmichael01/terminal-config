#!/usr/bin/env bash

if [ $(id -u) != 0 ]; then
    umask 0077
else
    umask 0022
fi

mkcd() {
    # about make a directory and cd into it
    # param path to create
    # example $ mkcd foo
    # example $ mkcd /tmp/img/photos/large
    mkdir -p "$*"
    cd "$*"
}

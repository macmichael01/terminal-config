#!/usr/bin/env bash

# TEXTMATE
case $OSTYPE in
  darwin*)
    # Textmate
    alias tm='mate . &'
    alias et='mate app config db lib public script test spec config.ru Gemfile Rakefile README &'
    ;;
esac

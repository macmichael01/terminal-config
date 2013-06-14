#!/usr/bin/env bash

TC_DIR=`pwd`

if [ -f ${TC_DIR}/bash/colors/colors.bash ]; then
    source ${TC_DIR}/bash/colors/colors.bash
fi

echo
echo "${echo_bold_purple} What's Available?${echo_reset_color}"
echo

# Determines what scripts are available for useage.
for directory in "aliases" "plugins" "completion" "dotfiles" "themes"
do
  echo -e "${echo_bold_cyan} $( echo ${directory} | tr [a-z] [A-Z]) ${echo_reset_color}"
  echo

  for file in `ls ${TC_DIR}/bash/${directory}/*`
  do
    case ${directory} in
      "themes")
          filename=$(echo ${file##*/})
          case $filename in
              *theme*)
              echo "   $(echo ${filename%.*})"
              ;;
          esac
      ;;
      *)
        filename=$(echo ${file##*/})
        echo "   $(echo ${filename%.*})"
      ;;
    esac
  done
  echo
done

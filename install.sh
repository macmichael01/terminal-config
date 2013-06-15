#!/usr/bin/env bash

# Terminal-config installation script.

# INSTALLATION STEPS:

# 0) Installation wizard.
# 1) Backup existing bash files.
# 2) Copy over the base bash files.
# 3) Copy or compile the bash color codes file.
# 4) Copy or compile the dotfile files.
# 5) Copy or compile the aliases, plugins, completion files.
# 6) Copy or compile a theme.
# 7) Copy or compile custom bash code file.

function usage() {
  echo
  echo -e "${echo_bold_cyan}TERMINAL-CONFIG${echo_reset_color}"
  echo
  echo -e "${echo_bold_yellow}ABOUT${echo_reset_color}"
  echo -e "  This Wizard will guide you through installing terminal"
  echo -e "  configuration scripts."
  echo
  echo -e "  ${echo_underline_white}NOTE${echo_reset_color}${echo_normal}: Any previously existing scripts that might get"
  echo -e "  overwritten will be backed up to the .BAK directory."
  echo
  echo -e "${echo_bold_green}INSTALLATION${echo_reset_color}"
  echo -e "  run ./install.sh and follow the wizard."
  echo
  echo -e "${echo_bold_purple}OPTIONAL ARGUMENTS${echo_reset_color}"
  echo -e "  -c, --compile          Compiles all shell scripts into a single file."
  echo -e "  -e, --email EMAIL      Email address used to parse into"
  echo -e "                         .dotfiles suchas .gitconfig."
  echo -e "  -b, --home HOME        Home directory to install these scripts."
  echo -e "                         Default: $HOME."
  echo -e "  -i, --install INSTALL  Installation type:"
  echo -e "                           1) Full Install."
  echo -e "                           2) Light Install."
  echo -e "                           3) Custom Install."
  echo -e "  -u, --user  USER       Unix username used to parse into "
  echo -e "                         .dotfiles suchas .gitconfig. Default: $USER."
  echo -e "  -s, --script SCRIPT    Custom script to include."
  echo -e "  -t, --theme THEME      Custom Bash theme to use."
  echo -e "  -v, --verbose          Verbosity"
  echo
}

OPTLIND=1
TC_DIR=`pwd`
DIR_DATE=$(date -u '+%b-%d-%Y-at-%H-%M-%S')
opt_verbose=false opt_compile=false opt_home=$HOME opt_user=$USER

# Load the bash colors file.
if [ -f ${TC_DIR}/bash/colors/colors.bash ]; then
    source ${TC_DIR}/bash/colors/colors.bash
fi

# Load getopts_long
if [ -f ${TC_DIR}/bash/plugins/getopts_long.plugins.bash ]; then
    source ${TC_DIR}/bash/plugins/getopts_long.plugins.bash
fi

while getopts_long b:ce:hi:s:t:u:v opt \
  compile no_argument \
  email required_argument \
  home required_argument \
  install required_argument \
  script required_argument \
  theme required_argument \
  user required_argument \
  verbose no_argument \
  help no_argument "" "$@"
do
  case "$opt" in
    b|home) opt_home=${OPTLARG-$home};;
    c|compile) opt_compile=true;;
    e|email) opt_email=${OPTLARG-$email};;
    h|help) usage; exit 0;;
    i|install) opt_install=${OPTLARG-$install};;
    s|script) opt_script=${OPTLARG-$script};;
    t|theme) opt_theme=${OPTLARG-$theme};;
    u|user) opt_user=${OPTLARG-$name};;
    v|verbose) opt_verbose=true;;
    :) printf >&2 '%s: %s\n' "${0##*/}" "$OPTLERR"
       usage
       echo "help"
       exit 1;;
  esac
done
shift "$(($OPTLIND - 1))"

echo -e "${echo_bold_cyan}+------------------------+${echo_reset_color}"
echo -e "${echo_bold_cyan}+ ${echo_bold_white}Terminal-config Wizard${echo_bold_cyan} +${echo_reset_color}"
echo -e "${echo_bold_cyan}+------------------------+${echo_reset_color}"

# 0) Installation wizard.

echo -e "${echo_bold_yellow}Username [${echo_white}$opt_user${echo_bold_yellow}]:${echo_reset_color}"
echo -en "${echo_green}==> ${echo_white}"
read opt_user

if [ -z "${opt_user}" ]; then
  opt_user=$USER
fi

echo -e "${echo_bold_yellow}Email [${echo_white}${opt_user}@localhost${echo_bold_yellow}]:${echo_reset_color}"
echo -en "${echo_green}==> ${echo_white}"
read opt_email

if [ -z "${opt_email}" ]; then
  opt_email="${opt_user}@localhost"
fi

if [ -z "${opt_install}" ]; then
  while true; do
  echo -e "${echo_bold_yellow}Select an installation:${echo_reset_color}"
  echo -e "${echo_white}1) Full Install${echo_reset_color}"
  echo -e "${echo_white}2) Minimal Install${echo_reset_color}"
  echo -e "${echo_white}3) Custom Install${echo_reset_color}"
  echo -en "${echo_green}==> ${echo_white}"
  read opt_install
  case "$opt_install" in
    1)
      break;;
    2)
      opt_filelist=( general.aliases git.aliases hg.aliases heroku.aliases \
                     extract.plugins files.plugins network.plugins \
                     nginx.plugins history.plugins password.plugins \
                     ssh.plugins system.plugins .gitinore .gitconfig )
      break;;
    3)
      echo -e "${echo_bold_yellow}Show available scripts [N/y]:${echo_reset_color}"
      echo -en "${echo_green}==> ${echo_white}"
      read opt_available
      echo
      case "$opt_available" in
        Y|y|yes|Yes|YES)
          for directory in "aliases" "plugins" "completions"; do
            echo -e "${echo_bold_cyan}$(echo ${directory} | tr [a-z] [A-Z]) ${echo_reset_color}"
            echo

            for file in `ls ${TC_DIR}/bash/${directory}/*`
            do
              filename=$(echo ${file##*/})
              echo " $(echo ${filename%.*})"
            done
            echo
          done
      esac
      echo -e "${echo_bold_yellow}Choose scripts to install (space separated):${echo_reset_color}"
      echo -e "${echo_white}e.g - ffmpeg.plugins git.aliases ...${echo_reset_color}"
      echo -en "${echo_green}==> ${echo_white}"
      read -a opt_filelist
      break;;
    *)
      echo -e "${echo_bold_red}  Invalid Choice${echo_reset_color}"
      echo
  esac
  done
  echo
fi

# 1) Backup existing bash files.
# Create the backup directory, if it doesn not exist.
if [ ! -d "${opt_home}/.BAK/" ]; then
  mkdir "${opt_home}/.BAK/"
fi

# Files being backed up are stored in a subdirectory by
# the date and time the scripts were installed.
if [ ! -d "${opt_home}/.BAK/$DIR_DATE" ]; then
  mkdir "${opt_home}/.BAK/$DIR_DATE"
fi

if [ "$opt_verbose" == "true" ]; then
  verbage="Backing up existing terminal files"
  echo -e "${echo_green}==> ${echo_white}${verbage}${echo_reset_color}"
fi
for file in "bashrc" "bash_profile" "profile" "bash_custom" "bash_theme"
do
  if [ -f ${opt_home}/.${file} ]; then
    mv "${opt_home}/.${file}" "${opt_home}/.BAK/${DIR_DATE}/.${file}"
  fi
done

# Backup any dotfiles
for file in `ls ${TC_DIR}/bash/dotfiles/*`
do
  filename=$(echo ${file##*/})
  dotfile=$(echo ${filename%%.*})
  if [ -f ${opt_home}/.${dotfile} ]; then
    mv "${opt_home}/.${dotfile}" "${opt_home}/.BAK/${DIR_DATE}/.${dotfile}"
  fi
done

# If the .bash directory already exists, move it to the backup directory.
if [ -d "${opt_home}/.bash/" ]; then
  mv "${opt_home}/.bash" "${opt_home}/.BAK/${DIR_DATE}/.bash"
fi

# 2) Create the base bash files.
if [ "$opt_compile" == "false" ]; then
  if [ "$opt_verbose" == "true" ]; then
    verbage="Creating the base bash files"
    verbage="$verbage\n    .bashrc"
    verbage="$verbage\n    .bash_profile"
    verbage="$verbage\n    .profile files"
    echo -e "${echo_green}==> ${echo_white}${verbage}${echo_reset_color}"
  fi
  for file in "bashrc" "bash_profile" "profile"; do
    cp "${TC_DIR}/bash/templates/${file}.template.bash" "${opt_home}/.${file}"
  done
else
  if [ "$opt_verbose" == "true" ]; then
    verbage="Creating the base bash files"
    verbage="$verbage\n    .bashrc"
    echo -e "${echo_green}==> ${echo_white}${verbage}${echo_reset_color}"
  fi
  cp "${TC_DIR}/bash/templates/bashrc.template.bash" "${opt_home}/.bashrc"
fi

# Recreate the .bash directory.
if [ "$opt_compile" == "false" ]; then
  mkdir "${opt_home}/.bash/"
fi

# 3) Copy or compile the bash color codes file.
if [ "$opt_verbose" == "true" ]; then
  verbage="Compiling the bash colors file"
  verbage="$verbage\n    colors.bash"
  if [ "$opt_compile" == "false" ]; then
    verbage="Creating the bash colors file"
    verbage="$verbage\n    colors.bash"
  fi
  echo -e "${echo_green}==> ${echo_white}${verbage}${echo_reset_color}"
fi

if [ "$opt_compile" == "false" ]; then
  mkdir "${opt_home}/.bash/colors"
  cp "${TC_DIR}/bash/colors/colors.bash" "${opt_home}/.bash/colors/colors.bash"
else
  # Strips out the shabang line
  tail +2 "${TC_DIR}/bash/colors/colors.bash" >> "${opt_home}/.bashrc"
fi

# 4) Copy or compile the dotfile files.
if [ "$opt_compile" == "false" ]; then
  if [ "$opt_verbose" == "true" ]; then
    if [ "$opt_install" == "1" ] || [[ $opt_filelist =~ ".dotfiles" ]]; then
      verbage="Creating dotfiles"
      echo -e "${echo_green}==> ${echo_white}${verbage}${echo_reset_color}"
    fi
  fi

  for file in `ls ${TC_DIR}/bash/dotfiles/*`; do
    dotfile=$(echo ${file##*/})
    filename=${dotfile%%.*}
    if [ "$opt_install" == "1" ]; then
      if [ "$opt_verbose" == "true" ]; then
        echo -e "    .${filename}${echo_reset_color}"
      fi
      render="sed -e 's/{{ opt_email }}/${opt_email}/g' -e 's/{{ opt_user }}/${opt_user}/g' ${TC_DIR}/bash/dotfiles/${dotfile} > ${opt_home}/.${filename}"
      eval $render
    else
      for script in ${opt_filelist[@]}; do
        if [ "${TC_DIR}/bash/dotfiles/${script}.bash" = "${file}" ]; then
          # File found, copy it.
          if [ "$opt_verbose" == "true" ]; then
            echo -e "    .${filename}${echo_reset_color}"
          fi
          render="sed -e 's/{{ opt_email }}/${opt_email}/g' -e 's/{{ opt_user }}/${opt_user}/g' ${TC_DIR}/bash/dotfiles/${dotfile} > ${opt_home}/.${filename}"
          eval $render
          break
        fi
      done
    fi
  done
fi

# 5) Copy or compile the aliases, plugins, completion files.
for directory in "aliases" "plugins" "completions"; do
  if [ "$opt_verbose" == "true" ]; then
    verbage="Compiling ${directory}"
    if [ "$opt_compile" == "false" ]; then
      verbage="Creating ${directory}"
    fi
    if [ "$opt_install" == "1" ] || [[ "${opt_filelist[@]}" =~ ".${directory}" ]]; then
      echo -e "${echo_green}==> ${echo_white}${verbage}${echo_reset_color}"
    fi
  fi
  for file in `ls ${TC_DIR}/bash/${directory}/*`; do
    # Check if the subdirectory exists, if not create it.
    if [ "$opt_compile" == "false" ] && [ ! -d "${opt_home}/.bash/${directory}" ]; then
        mkdir "${opt_home}/.bash/${directory}"
    fi
    filename="$(echo ${file##*/})"
    if [ ${#opt_filelist[@]} -gt 0 ]; then
      for script in ${opt_filelist[@]}; do
        if [ "${script}.bash" == "${filename}" ]; then
          if [ "$opt_compile" == "false" ]; then
            verbage="${echo_green}    ${echo_white}${directory}${echo_white}${filename}"
            # File found, copy it.
            cp "${file}" "${opt_home}/.bash/${directory}/${filename}"
          else
            # File found, tail it.
            tail +2 "${file}" >> "${opt_home}/.bashrc"
          fi
          if [ "$opt_verbose" == "true" ]; then
            verbage="${filename}"
            echo -e "${echo_green}    ${echo_white}${verbage}${echo_reset_color}"
          fi
          break
        fi
      done
    else
      if [ "$opt_compile" == "false" ]; then
        verbage="${filename}"
        # File found, copy it.
        cp "${file}" "${opt_home}/.bash/${directory}/${filename}"
      else
        verbage="${filename}"
        # File found, tail it.
        tail +2 "${file}" >> "${opt_home}/.bashrc"
      fi
      if [ "$opt_verbose" == "true" ]; then
        echo -e "    ${verbage}${echo_reset_color}"
      fi
    fi
  done
done

# 6) Copy or compile a theme.
if [ ! -z "$opt_theme" ]; then

  for theme in `find ${TC_DIR}/bash/themes/ -type f ! -iname '*.theme'`; do
    filepath="$(echo ${theme%%:*/})"
    filename="$(echo ${theme##*/})"
    name="$(echo ${filename%.*})"
    # Name should match something like default.theme
    if [ "$name" == "$opt_theme" ]; then
      if [ "$opt_compile" == "false" ]; then
        verbage="${echo_green}==> ${echo_white}Creating theme${echo_white}"
        cp "${theme}" "${opt_home}/.bash_theme"
      else
        verbage="${echo_green}==> ${echo_white}Compiling theme${echo_white}"
        tail +2 "${theme}" >> "${opt_home}/.bashrc"
      fi
      if [ "$opt_verbose" == "true" ]; then
        echo -e "${echo_cyan}${verbage}${echo_reset_color}"
        echo -e "    ${name}"
      fi
    fi
  done
fi

# 7) Copy or compile custom bash code file.
if [ ! -z "$opt_script" ] && [ -f "$opt_script" ]; then
  if [ "$opt_compile" == "false"  ]; then
    verbage="${echo_green}==> ${echo_white}Creating custom script"
    cp "$opt_script" "${opt_home}/.bash_custom"
  else
    verbage="${echo_green}==> ${echo_white}Compiling custom script"
    tail +2 "${opt_script}" >> "${opt_home}/.bashrc"
  fi
  if [ "$opt_verbose" == "true" ]; then
    echo -e "${echo_cyan}${verbage}${echo_reset_color}"
  fi
fi

echo
echo -e "${echo_green}All done, Enjoy!${echo_reset_color}"
echo

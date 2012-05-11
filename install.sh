#!/usr/bin/env bash

# Terminal-config installation script.

# INSTALLATION STEPS:

# 1) Backup existing bash files.
# 2) Copy over the base bash files.
# 3) Copy over colors codes.
# 4) Copy over aliases, plugins, completion, and dotfiles.
# 5) Copy over a theme.
# 6) Copy custom bash code.

TC_DIR=`pwd`

# Load the bash colors file.
if [ -f ${TC_DIR}/bash/colors/colors.bash ]; then
    source ${TC_DIR}/bash/colors/colors.bash
fi

echo
echo -e " ${echo_white}..::Terminal-config Wizard::..${echo_reset_color}"

# 1) Backup existing bash files.
DIR_DATE=$(date -u '+%Y-%b-%d_%H:%M:%S')

# Create the backup directory, if it doesn not exist.
if [ ! -d "$HOME/.BAK/" ]
then
  mkdir "$HOME/.BAK/"
fi

# Files being backed up are stored in date subdirectory,
# In case this script is ran multiple times
# backup files won't get clobbered
if [ ! -d "$HOME/.BAK/$DIR_DATE" ]
then
  mkdir "$HOME/.BAK/$DIR_DATE"
fi

echo -e " ${echo_cyan}Backing up existing terminal files...${echo_reset_color}"
for file in "bashrc" "bash_profile" "profile" "bash_custom" "bash_theme"
do  
  if [ -f $HOME/.${file} ]; then
    cp $HOME/.${file} $HOME/.BAK/${DIR_DATE}/.${file}
  fi
done

# Backup dotfiles
for file in `ls ${TC_DIR}/bash/dotfiles/*`
do
  filename=$(echo ${file##*/})
  dotfile=$(echo ${filename%%.*})
  if [ -f $HOME/.${dotfile} ]; then
    cp $HOME/.${dotfile} $HOME/.BAK/${DIR_DATE}/.${dotfile}
  fi
done

# If the .bash directory already exists. Move the entire
# folder since it will get recreated.
if [ -d "$HOME/.bash/" ]
then
  mv $HOME/.bash $HOME/.BAK/${DIR_DATE}/.bash
fi

# 2) Copy over the base bash files.
verbage='Copying the base terminal files...'
if [ ! -z "$TC_COMPILE" ]; then
  verbage='Compiling the base terminal files...'
fi
echo -e " ${echo_cyan}${verbage}${echo_reset_color}"
for file in "bashrc" "bash_profile" "profile"
do
  cp "${TC_DIR}/bash/templates/${file}.template.bash" "$HOME/.${file}"
done

# Recreate the .bash directory.
if [ -z "$TC_COMPILE" ]; then
  if [ ! -d "$HOME/.bash/" ]; then
    mkdir "$HOME/.bash/"
  fi
fi

# 3) Copy over colors.
verbage='Copying the bash color codes'
if [ ! -z "$TC_COMPILE" ]; then
  verbage='Compiling terminal color and appearance scripts...'
fi
echo -e " ${echo_cyan}${verbage}${echo_reset_color}"
if [ -z "$TC_COMPILE" ]; then
  if [ ! -d "$HOME/.bash/colors" ]; then
    mkdir "$HOME/.bash/colors"
  fi
  cp "${TC_DIR}/bash/colors/colors.bash" "${HOME}/.bash/colors/colors.bash"
else
  # Strips out the
  tail +2 "${TC_DIR}/bash/colors/colors.bash" >> "${HOME}/.bashrc"
fi

# 4) Copy over aliases, plugins, completion, and dotfiles.

# Tell bash which scripts to install from ./available.sh
if [ ! -z "$TC_INSTALL" ]; then
  echo 
  echo -e " ${echo_cyan}Which script(s) should be installed (space delimited)? ${echo_reset_color}"
  read -p " >> " INSTALL_THESE
  echo
fi

for directory in "aliases" "plugins" "completion" "dotfiles"
do
    # TODO: There's got to be a better way to check for this.
    if [ "${directory}" = "aliases" ]; then
      if [ ! -z "$TC_NO_ALIASES" ]; then
        continue
      fi
    fi

    if [ "${directory}" = "plugins" ]; then
      if [ ! -z "$TC_NO_PLUGINS" ]; then
        continue
      fi
    fi

    if [ "${directory}" = "completion" ]; then
      if [ ! -z "$TC_NO_COMPLETION" ]; then
        continue
      fi
    fi
    
    if [ "${directory}" = "dotfiles" ]; then
      if [ ! -z "$TC_NO_DOTFILES" ]; then
        continue
      fi
    fi
    
    if [ "${directory}" = "dotfiles" ]; then
      verbage="Copying dotfiles..."
      echo -e " ${echo_cyan}${verbage}${echo_reset_color}"
      for file in `ls ${TC_DIR}/bash/dotfiles/*`
      do
        dotfile=$(echo ${file##*/})
        filename=${dotfile%%.*}
        if [ ${#INSTALL_THESE[@]} -gt 0 ]; then
          for script in ${INSTALL_THESE[@]}
          do
            if [ "${TC_DIR}/bash/${directory}/${script}.bash" = "${file}" ]; then
                # File found, copy it.
                cp "${file}" "$HOME/.${script}"
                break
            fi
          done
        else
          # Copy all
          cp "${file}" "$HOME/.${filename}"
        fi
      done
      continue
    fi

  # Skip if a user specified environment var exsists.      
  verbage="Copying the bash ${directory} scripts..."
  if [ ! -z "$TC_COMPILE" ]; then
    verbage="Merging the bash ${directory} scripts..."
  fi  
  echo -e " ${echo_cyan}${verbage}${echo_reset_color}"

  # Check if the bash base directory exists. used only if preserve is enabled.
  if [ -z "$TC_COMPILE" ]; then
    if [ ! -d "$HOME/.bash/" ]; then
      mkdir "$HOME/.bash/"
    fi
  fi

  for file in `ls ${TC_DIR}/bash/${directory}/*`
  do
    if [ -z "$TC_COMPILE" ]; then
      # Check if the sub directory exists, if not create it.
      if [ ! -d "$HOME/.bash/${directory}" ]; then
        mkdir "$HOME/.bash/${directory}"
        # " " >> "$HOME/.bash/${directory}/.ignore"
      fi
    fi

    if [ ${#INSTALL_THESE[@]} -gt 0 ]; then
      for script in ${INSTALL_THESE[@]}
      do
        if [ "${TC_DIR}/bash/${directory}/${script}.bash" = "${file}" ]; then
          if [ ! -z "$TC_COMPILE" ]; then
            # File found, tail it.
            tail +2 "${file}" >> "${HOME}/.bashrc"
            break
          else
            # File found, copy it.
            cp "${file}" "$HOME/.bash/${directory}/${script}.bash"
            break
          fi
        fi
      done
    else # Using all files
      if [ ! -z "$TC_COMPILE" ]; then
        # Merge the file into the bashrc file.
        tail +2 "${file}" >> "${HOME}/.bashrc"
      else
        # Copy files.
        filename="$(echo ${file##*/})"
        cp "${file}" "${HOME}/.bash/${directory}/${filename}"
      fi
    fi
  done
done

# 5) Copy over a theme.
if [ ! -z "$TC_THEME" ]; then
  for theme in `ls ${TC_DIR}/bash/themes/*`
  do
    case $theme in
      "themes")
          filename=$(echo ${theme##*/})
          case $filename in
              *theme*)
              name="$(echo ${filename%.*})"
              # Name should match something like default.theme
              if [ $name -eq $filename]; then
                if [ ! -z "$TC_COMPILE" ]; then  
                  cp $TC_CUSTOM $HOME/.bash_theme
                else
                  tail +2 $theme >> "$HOME/.bashrc"
                fi
              fi
              ;;
          esac
      ;;
    esac
  done
fi

# 5) Select a theme to use
if [ ! -z "$TC_THEME" ]; then
  echo 
  echo -e " ${echo_cyan}Which theme should be installed (some.theme)? ${echo_reset_color}"
  read -p " >> " USE_THEME

  filename=$(echo ${USE_THEME%.*})
  if [ -f "${TC_DIR}/bash/themes/${filename}/${USE_THEME}.bash" ]; then
    verbage="Copying the theme '${USE_THEME}'... "
    if [ ! -z "$TC_COMPILE" ]; then
      verbage="Merging the theme '${USE_THEME}'... "
    fi
    echo -e " ${echo_cyan}${verbage}${echo_reset_color}"
    if [ ! -z "$TC_COMPILE" ]; then  
      tail +2 "${TC_DIR}/bash/themes/${filename}/${USE_THEME}.bash" >> "$HOME/.bash_theme"
    else
      cp "${TC_DIR}/bash/themes/${filename}/${USE_THEME}.bash" "$HOME/.bash_theme"
    fi
  else
    echo
    echo -e " ${echo_bold_red}Theme does not exist.${echo_reset_color}${echo_normal}"
  fi
fi

# 6) Custom include code.
if [ ! -z "$TC_CUSTOM" ]; then
  echo 
  echo -e " ${echo_cyan}Which custom script should be installed (/path/to/file.bash)? ${echo_reset_color}"
  read -p " >> " USE_CUSTOM

  if [ -f "$USE_CUSTOM" ]; then
    verbage="Copying the script at: ${USE_THEME}... "
    if [ ! -z "$TC_COMPILE" ]; then
      verbage="Merging the script at: ${USE_THEME}... "
    fi
    echo -e " ${echo_cyan}${verbage}${echo_reset_color}"
    if [ ! -z "$TC_COMPILE" ]; then  
      tail +2 "${USE_CUSTOM}" >> "$HOME/.bash_custom"
    else
      cp "$USE_CUSTOM" "$HOME/.bash_custom"
    fi
  else
    echo
    echo -e " ${echo_bold_red}File does not exist.${echo_reset_color}${echo_normal}"
  fi
fi

echo
echo -e " ${echo_green}All done, Enjoy!${echo_reset_color}"
echo

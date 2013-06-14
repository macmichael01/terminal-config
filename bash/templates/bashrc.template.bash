#!/usr/bin/env bash

# Return if not running interactively.
[ -z "$PS1" ] && return

if [ -f "$HOME/.bash/colors/colors.bash" ]
then
 source "$HOME/.bash/colors/colors.bash"
fi

# COLORIZE grep
export GREP_OPTIONS='--color=auto'
# export GREP_OPTIONS='--color=auto --exclude="tags" --exclude="TAGS" --exclude="TAGS" --exclude=.git* --exclude=.svn* --exclude=log*'
export GREP_COLOR='1;33'

# COLORIZE ls
# http://geoff.greer.fm/lscolors/
export CLICOLOR=1
case $( uname -s ) in
     Darwin )
       export LSCOLORS='ExGxcxdxCxegedabagacad'
        ;;
     Linux )
       export LS_COLORS="di=1;;40:ln=1;;40:so=32;40:pi=33;40:ex=1;;40:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43"
        ;;
esac

# COLORIZE prompt
# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) COLOR_PROMPT=yes;;
esac

# Force color prompt
COLOR_PROMPT_FORCE=yes

if [ -n "$COLOR_PROMPT_FORCE" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        COLOR_PROMPT=yes
    else
        COLOR_PROMPT=
    fi
fi

if [ "$COLOR_PROMPT" = yes ]; then
    # Remote termnal color support.
    if ps ax | grep ^$PPID'.*sshd' &> /dev/null; then
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;31m\]\u\[\033[00m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
    else
        PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w \$\[\033[00m\] '
        export SUDO_PS1="${debian_chroot:+($debian_chroot)}\[\e[33;1;41m\]\u@\h:\w \$\[\033[00m\] "
    fi
    # TODO: Fix color isse
    # if ps ax | grep ^$PPID'.*sshd' &> /dev/null; then
    #     PS1='${bold_red}${debian_chroot:+($debian_chroot)}\u${reset_color}@${bold_green}\h${bold_white}:${bold_blue}\w \$${color_reset} '
    # else # Local Terminal color support.
    #     PS1='${bold_green}${debian_chroot:+($debian_chroot)}${bold_green}\u@\h${bold_white}:${bold_blue}\w \$${color_reset} '
    #     export PS1
    #     SUDO_PS1="${background_red}${bold_yellow}${debian_chroot:+($debian_chroot)}\u@\h:\w \$${color_reset} "
    # fi
else
    # No Color
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi

unset COLOR_PROMPT COLOR_PROMPT_FORCE

# If this is an xterm set the title to user@host:dir
case "$TERM" in
    xterm*|rxvt*)
      PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
    *)
    ;;
esac

# COLORIZE dir.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
fi

# COLORIZE grep
if [ -x /usr/bin/dircolors ]; then
    # Auto color grep
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# Load RVM, if you are using it
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# ENVIRONMENT SETTINGS
export PATH="/usr/local/bin:$PATH"      # So that Homebrew does not complain
export PATH="$HOME/bin:$PATH"
export PATH=$PATH:~/.gem/ruby/1.8/bin   # Add rvm gems to the path
export PATH=$PATH:$(which nginx)        # Add nginx to the path
export GIT_HOSTING='git@git.domain.com' # I use this for private repos.
export IRC_CLIENT='irssi'               # Console based IRC client.
export NGINX_PATH=$(which nginx)        # Set the path nginx
export TODO="t"                         # For use with todo.txt-cli

export EDITOR="vim" # TODO: Pick based on os.
export EDITOR="/usr/bin/mate -w" # Set my editor and git editor
export LESS="-X -M -E -R"
export PAGER="less"
export VIM="$(which vim)"
export VISUAL="vim"
export GIT_EDITOR='/usr/bin/mate -w'
export SVN_EDITOR="vim"
export PSQL_EDITOR='vim -c"set syntax=sql"'

export RI="--format ansi -T"

export THEME_PROMPT_HOST='\H'
export SCM_THEME_PROMPT_DIRTY=' ✗'
export SCM_THEME_PROMPT_CLEAN=' ✓'
export SCM_THEME_PROMPT_PREFIX=' |'
export SCM_THEME_PROMPT_SUFFIX='|'

export SCM_GIT='git'
export SCM_GIT_CHAR='±'

export SCM_HG='hg'
export SCM_HG_CHAR='☿'

export SCM_SVN='svn'
export SCM_SVN_CHAR='⑆'

export SCM_NONE='NONE'
export SCM_NONE_CHAR='○'

export RVM_THEME_PROMPT_PREFIX=' |'
export RVM_THEME_PROMPT_SUFFIX='|'

export VIRTUALENV_THEME_PROMPT_PREFIX=' |'
export VIRTUALENV_THEME_PROMPT_SUFFIX='|'

export RBENV_THEME_PROMPT_PREFIX=' |'
export RBENV_THEME_PROMPT_SUFFIX='|'

export RBFU_THEME_PROMPT_PREFIX=' |'
export RBFU_THEME_PROMPT_SUFFIX='|'

export PREVIEW="less"
[ -s /usr/bin/gloobus-preview ] && PREVIEW="gloobus-preview"
[ -s /Applications/Preview.app ] && PREVIEW="/Applications/Preview.app"
unset MAILCHECK # Don't check mail when opening terminal.

if [[ $PROMPT ]]; then
    export PS1=$PROMPT
fi

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/xvzf/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# Load Jekyll
if [ -e $HOME/.jekyllconfig ]
then
  . $HOME/.jekyllconfig
fi

function scm {
  if [[ -d .git ]]; then SCM=$SCM_GIT
  elif [[ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]]; then SCM=$SCM_GIT
  elif [[ -d .hg ]]; then SCM=$SCM_HG
  elif [[ -n "$(hg root 2> /dev/null)" ]]; then SCM=$SCM_HG
  elif [[ -d .svn ]]; then SCM=$SCM_SVN
  else SCM=$SCM_NONE
  fi
}

function scm_prompt_char {
  if [[ -z $SCM ]]; then scm; fi
  if [[ $SCM == $SCM_GIT ]]; then SCM_CHAR=$SCM_GIT_CHAR
  elif [[ $SCM == $SCM_HG ]]; then SCM_CHAR=$SCM_HG_CHAR
  elif [[ $SCM == $SCM_SVN ]]; then SCM_CHAR=$SCM_SVN_CHAR
  else SCM_CHAR=$SCM_NONE_CHAR
  fi
}

function scm_prompt_vars {
  scm
  scm_prompt_char
  SCM_DIRTY=0
  SCM_STATE=''
  [[ $SCM == $SCM_GIT ]] && git_prompt_vars && return
  [[ $SCM == $SCM_HG ]] && hg_prompt_vars && return
  [[ $SCM == $SCM_SVN ]] && svn_prompt_vars && return
}

function scm_prompt_info {
  scm
  scm_prompt_char
  SCM_DIRTY=0
  SCM_STATE=''
  [[ $SCM == $SCM_GIT ]] && git_prompt_info && return
  [[ $SCM == $SCM_HG ]] && hg_prompt_info && return
  [[ $SCM == $SCM_SVN ]] && svn_prompt_info && return
}

function git_prompt_vars {
  if [[ -n $(git status -s 2> /dev/null |grep -v ^# |grep -v "working directory clean") ]]; then
    SCM_DIRTY=1
     SCM_STATE=${GIT_THEME_PROMPT_DIRTY:-$SCM_THEME_PROMPT_DIRTY}
  else
    SCM_DIRTY=0
     SCM_STATE=${GIT_THEME_PROMPT_CLEAN:-$SCM_THEME_PROMPT_CLEAN}
  fi
  SCM_PREFIX=${GIT_THEME_PROMPT_PREFIX:-$SCM_THEME_PROMPT_PREFIX}
  SCM_SUFFIX=${GIT_THEME_PROMPT_SUFFIX:-$SCM_THEME_PROMPT_SUFFIX}
  local ref=$(git symbolic-ref HEAD 2> /dev/null)
  SCM_BRANCH=${ref#refs/heads/}
  SCM_CHANGE=$(git rev-parse HEAD 2>/dev/null)
}

function svn_prompt_vars {
  if [[ -n $(svn status 2> /dev/null) ]]; then
    SCM_DIRTY=1
      SCM_STATE=${SVN_THEME_PROMPT_DIRTY:-$SCM_THEME_PROMPT_DIRTY}
  else
    SCM_DIRTY=0
      SCM_STATE=${SVN_THEME_PROMPT_CLEAN:-$SCM_THEME_PROMPT_CLEAN}
  fi
  SCM_PREFIX=${SVN_THEME_PROMPT_PREFIX:-$SCM_THEME_PROMPT_PREFIX}
  SCM_SUFFIX=${SVN_THEME_PROMPT_SUFFIX:-$SCM_THEME_PROMPT_SUFFIX}
  SCM_BRANCH=$(svn info 2> /dev/null | awk -F/ '/^URL:/ { for (i=0; i<=NF; i++) { if ($i == "branches" || $i == "tags" ) { print $(i+1); break }; if ($i == "trunk") { print $i; break } } }') || return
  SCM_CHANGE=$(svn info 2> /dev/null | sed -ne 's#^Revision: ##p' )
}

function hg_prompt_vars {
    if [[ -n $(hg status 2> /dev/null) ]]; then
      SCM_DIRTY=1
        SCM_STATE=${HG_THEME_PROMPT_DIRTY:-$SCM_THEME_PROMPT_DIRTY}
    else
      SCM_DIRTY=0
        SCM_STATE=${HG_THEME_PROMPT_CLEAN:-$SCM_THEME_PROMPT_CLEAN}
    fi
    SCM_PREFIX=${HG_THEME_PROMPT_PREFIX:-$SCM_THEME_PROMPT_PREFIX}
    SCM_SUFFIX=${HG_THEME_PROMPT_SUFFIX:-$SCM_THEME_PROMPT_SUFFIX}
    SCM_BRANCH=$(hg summary 2> /dev/null | grep branch | awk '{print $2}')
    SCM_CHANGE=$(hg summary 2> /dev/null | grep parent | awk '{print $2}')
}

function rvm_version_prompt {
  if which rvm &> /dev/null; then
    rvm=$(rvm tools identifier) || return
    echo -e "$RVM_THEME_PROMPT_PREFIX$rvm$RVM_THEME_PROMPT_SUFFIX"
  fi
}

function rbenv_version_prompt {
  if which rbenv &> /dev/null; then
    rbenv=$(rbenv version-name) || return
    echo -e "$RBENV_THEME_PROMPT_PREFIX$rbenv$RBENV_THEME_PROMPT_SUFFIX"
  fi
}

function rbfu_version_prompt {
  if [[ $RBFU_RUBY_VERSION ]]; then
    echo -e "${RBFU_THEME_PROMPT_PREFIX}${RBFU_RUBY_VERSION}${RBFU_THEME_PROMPT_SUFFIX}"
  fi
}

function ruby_version_prompt {
  echo -e "$(rbfu_version_prompt)$(rbenv_version_prompt)$(rvm_version_prompt)"
}

function virtualenv_prompt {
  if which virtualenv &> /dev/null; then
    virtualenv=$([ ! -z "$VIRTUAL_ENV" ] && echo "`basename $VIRTUAL_ENV`") || return
    echo -e "$VIRTUALENV_THEME_PROMPT_PREFIX$virtualenv$VIRTUALENV_THEME_PROMPT_SUFFIX"
  fi
}

# backwards-compatibility
function git_prompt_info {
  git_prompt_vars
  echo -e "$SCM_PREFIX$SCM_BRANCH$SCM_STATE$SCM_SUFFIX"
}

function svn_prompt_info {
  svn_prompt_vars
  echo -e "$SCM_PREFIX$SCM_BRANCH$SCM_STATE$SCM_SUFFIX"
}

function hg_prompt_info() {
  hg_prompt_vars
  echo -e "$SCM_PREFIX$SCM_BRANCH:${SCM_CHANGE#*:}$SCM_STATE$SCM_SUFFIX"
}

function scm_char {
  scm_prompt_char
  echo -e "$SCM_CHAR"
}

function prompt_char {
    scm_char
}

# Load the files in the .bash/ directory.

if [ -d "$HOME/.bash/aliases/" ]
then
  for file in `ls $HOME/.bash/aliases/*`
  do
    if [ -f "${file}" ]; then
        source $file
    fi
  done
fi

if [ -d "$HOME/.bash/plugins" ]
then
  for file in `ls $HOME/.bash/plugins/*`
  do
    if [ -f "${file}" ]; then
        source $file
    fi
  done
fi

if [ -d "$HOME/.bash/completion/" ]
then
  for file in `ls $HOME/.bash/completion/*`
  do
    if [ -f "${file}" ]; then
        source $file
    fi
  done
fi

if [ -f "$HOME/.bash_etc" ]
then
  source $HOME/.bash_etc
fi

function bash-help() {
  echo "Welcome to Bash help"
  echo
  echo "  rails-help                  This will list out all the aliases you can use with rails."
  echo "  git-help                    This will list out all the aliases you can use with git."
  echo "  todo-help                   This will list out all the aliases you can use with todo.txt-cli"
  echo "  brew-help                   This will list out all the aliases you can use with Homebrew"
  echo "  aliases-help                Generic list of aliases."
  echo "  plugins-help                This will list out all the plugins and functions you can use with bash-it"
  echo
}

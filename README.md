**ABOUT**

A collection of terminal related configurations and scripts to enhance
the bash experience. This repository is based on Bash-It. The main 
difference is how the scripts are installed. My goal was to make the ultimate 
terminal configuration.

The reason I added an option to merge all bash related scripts into
a single bash file was so one could make use of this library 
[remotebashrc][1] which allows for a local bash config to carried over to
to any remote server without tampering with the default 
remote terminal configurations.

**HOW IT WORKS**

This script, when installed copies over bash related aliases, plugins,
and auto-completion scripts to the .bash/ directory under
a user's home directory. If the TC_COMPILE environment variable is enabled,
all bash related scripts will be merged into the .bashrc file. There are also 
a collection of bash related themes that can be used to provide specific
behavior and color stylings. Lastly, dotfiles suchas .gitconfig will 
get copied over to a users home directory as well.

**INSTALLATION**

Copy the following command into a terminal:

    git clone LOCATION HERE;
    cd terminal-config
    ./install.sh

**ADDITIONAL OPTIONS**

Use the following environment variables to customize how the script is ran.

TC_COMPILE

Terminal-config, by default, copies bash related scripts to the .bash/
directory. If the TC_COMPILE environment variable is set, bash related
code will be merged into the .bashrc file.

    export TC_COMPILE=1

TC_THEME

Custom theme to be used a specific user experience. when enabled
a prompt appears during installation asking for a theme name.

    export TC_THEME=1

TC_CUSTOM

Install a custom bash related script. This file will be loaded at
the end of the installation process and stored in a file called .bash_custom.
When enabled a prompt appears during installation asking for the path
to the file to include.

    export TC_CUSTOM=1

TC_INSTALL

Choosing what to install could be handy if your terminal session is 
taking forever to load. Completion scripts in particular might be responsible 
for causing such slowness.

When enabled, a prompt will appear asking to select the script(s) that you
would like installed. A full list of available scripts can be found by 
running the ./available.sh script. By default, all scripts are loaded.

Scripts to be installed applies to aliases, plugins, completion, and dotfiles.

    export TC_INSTALL=1

*NOTE*: If any of the TC_NO_* environment variables below are set, none of
the scripts from that category will get installed regardless
if a script is passed to the TC_INSTALL prompt.
*e.g =* 

    export TC_NO_ALIASES=1, TC_INSTALL=1
    
    Which scripts should be installed (space delimited)?
    >> git.aliases git.completion
    'git.aliases' will NOT get installed but 'git.completion' will.


TC_NO_ALIASES

Ignore alias scripts.

    export TC_NO_ALIASES=1

TC_NO_PLUGINS

Ignore plugin scripts.

    export TC_NO_PLUGINS=1

TC_NO_COMPLETION

Ignore completion scripts.

    export TC_NO_COMPLETION=1

TC_NO_DOTFILES

Ignore copying over dot files.

    export TC_NO_DOTFILES=1    

**TODOS**

- Add more dot files.
- Continue testing this script for bugs.

Enjoy!

 [1] https://github.com/justyns/remotebashrc

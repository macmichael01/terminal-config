ABOUT
-----

Terminal-config is a collection of shell related scripts used to enhance
the bash experience. This repository is based on Bash-It. The main difference
is that Terminal-config comes with a handy installer wizard along with a
few of my own scripts.


INSTALLATION
------------

*Copy the following command into a terminal window*

    bash <(curl -s -L http://goo.gl/3P3Gn)

*Alternatively*

    git clone git://github.com/macmichael01/terminal-config.git;
    cd terminal-config;
    ./install.sh -v;


INSTALLATION OPTIONS
--------------------

The Wizard has 3 installation types to choose from.

1) Full install - Installs everything.

2) Minimal install - Installs only the most basic items.

    .bashrc .bash_profile .profile colors.bash

    general.aliases git.aliases hg.aliases heroku.aliases
    extract.plugins files.plugins network.plugins
    nginx.plugins history.plugins password.plugins
    ssh.plugins system.plugins .gitinore .gitconfig

3) Custom install - Choose what you want installed.


ADDITIONAL OPTIONS
------------------

      -c, --compile          Compiles all shell scripts into a single file.
      -e, --email EMAIL      Email address used to parse into
                             .dotfiles suchas .gitconfig.
      -b, --home HOME        Home directory to install these scripts.
                             Default: $HOME.
      -i, --install INSTALL  Installation type:
                               1) Full Install.
                               2) Light Install.
                               3) Custom Install.
      -u, --user  USER       Unix username used to parse into
                             .dotfiles suchas .gitconfig. Default: $USER.
      -s, --script SCRIPT    Custom script to include.
      -t, --theme THEME      Custom Bash theme to use.
      -v, --verbose          Verbosity

Find out which scripts are available:

    ./available.sh

Find out which scripts are currently installed:

    ./enabled.sh

Enjoy!

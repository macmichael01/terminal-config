#!/usr/bin/env bash

#display top 10 cpu-using processes, and top 10 cpu-using users

function usefulstuff() {
  echo -e "$green Uptime: $red `uptime` \e[m"
  echo -e "$green Total procs: $red `ps aux | wc -l` \e[m"
  services="httpd mysqld apache2 proftpd qmail-send master sendmail"
  echo -ne "$green Services: \e[m";for serv in $services; do [ ! "$(pidof $serv)" ] && echo -ne "$serv:$red Off\e[m " || echo -ne "$serv:$green On\e[m "; done;echo ""

}

#utime converts unix-time to ..normal time
function utime() { perl -e "print localtime($1).\"\n\"";}
function topproc10() { ps -eo pcpu,pmem,user,pid,cmd | sort -r | head -10; }
function topproc10u() { ps -eo user,pcpu,pmem | tail -n +2 | awk '{num[$1]++; cpu[$1] += $2; mem[$1] += $3} END{printf("NPROC\tUSER\tCPU\tMEM\n"); for (user in cpu) printf("%d\t%s\t%.2f\t%.2f\n",num[user], user, cpu[user], mem[user]) }'; }

usage() {
    # about disk usage per directory, in Mac OS X and Linux
    # param 1: directory name
    if [ $(uname) = "Darwin" ]; then
        if [ -n $1 ]; then
            du -hd $1
        else
            du -hd 1
        fi

    elif [ $(uname) = "Linux" ]; then
        if [ -n $1 ]; then
            du -h --max-depth=1 $1
        else
            du -h --max-depth=1
        fi
    fi
}

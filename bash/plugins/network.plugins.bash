#!/usr/bin/env bash

#test_site_speed times how long it takes to do a dns lookup and download a website

ips() {
    # about display all ip addresses for this host
    ifconfig | grep "inet " | awk '{ print $2 }'
}

down4me() {
    # about checks whether a website is down for you, or everybody
    # param 1: website url
    # example $ down4me http://www.google.com
    curl -s "http://www.downforeveryoneorjustme.com/$1" | sed '/just you/!d;s/<[^>]*>//g'
}

myip() {
    # about displays your ip address, as seen by the Internet
    res=$(curl -s checkip.dyndns.org | grep -Eo '[0-9\.]+')
    echo -e "Your public IP is: ${echo_bold_green} $res ${echo_normal}"
}

function sitespeed() {
  URL="${1}";
  curl -L --w "$URL\nDNS %{time_namelookup}s conn %{time_connect}s time %{time_total}s\nSpeed %{speed_download}bps Size %{size_download}bytes\n" -o/dev/null -s $URL
}

function whatismyip(){ wget -q -O - checkip.dyndns.org|sed -e 's/.*Current IP Address: //' -e 's/<.*$//'; }

function netstat2() {
	case "$1" in

	"ipcount"  )
		netstat -nat | grep ":80" | awk -F: '{print $8}' | sort | uniq -c | sort -n;;
	"top20" )
		netstat -nat | grep ":80" | awk -F: '{print $8}' | sort | uniq -c | sort -n | awk '{ if ( $1 > 20 ) print $2 ; }';;
	* )
		echo "Run netstat2 with one of these commands:"
		echo "ipcount: lists all of the ips connected to the server sorted by the number of connections they have open"
		echo "top20: Same as above but only lists the top 20 and does not display the number of connections open per ip"
	;;
	esac;
}

function ifstatus() {
	IFIP=$(/sbin/ifconfig eth0 | awk "/inet/ { print $2 } " | sed -e s/addr://)
	IFISP=$(/sbin/ifconfig eth0 | awk "/P-t-P/ { print $3 } " | sed -e s/P-t-P://)
}

function ii() {
	echo -e "${IYellow}You are logged on to: ${ColorOff}\n$HOSTNAME$NC"
	echo -e "\n${IYellow}Additionnal information:${ColorOff}$NC" ; uname -a
	echo -e "\n${IYellow}Users logged on:${ColorOff}$NC " ; w -h
	echo -e "\n${IYellow}Current date:${ColorOff}$NC " ; date
	echo -e "\n${IYellow}Machine stats:${ColorOff}$NC " ; uptime
	echo -e "\n${IYellow}Memory stats:${ColorOff}$NC " ; free
	ifstatus 2>&- ;
	echo -e "\n${IYellow}Local IP Address:${ColorOff}$NC" ; echo ${IFIP:-"Not connected"}
	echo -e "\n${IYellow}ISP Address:${ColorOff}$NC" ; echo ${IFISP:-"Not connected"}
}

function pss() {
	ps $@ -u $USER -o pid,%cpu,%mem,bsdtime,command ;
}

function pp() {
	pss f | awk '!/awk/ && $0~var' var=${1:-".*"} ;
}

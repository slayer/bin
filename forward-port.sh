#!/bin/sh


if [ -z "$1" -o -z "$2" ]; then
  echo "Usage $0" port[/tcp] [localaddr]-daddr[:port]
  echo "   ex $0" 3080 10.10.1.1-10.10.10.20:80
	exit
fi


proto=tcp
sudo="`which sudo`"
# sudo="echo " # debug

port="`echo $1 | cut -d/ -f1`"
p="`echo $1 | cut -d/ -f2`"
[ "$p" != "$port" ] && proto="$p"

daddr="$2"
if [ "`echo $daddr | cut -d- -f2`" != "$daddr" ]; then
	laddr="`echo $daddr | cut -d- -f1`"
	daddr="`echo $daddr | cut -d- -f2`"
fi

if [ "`echo $daddr | cut -d: -f2`" != "$daddr" ]; then
	dport="`echo $daddr | cut -d: -f2`"
	daddr="`echo $daddr | cut -d: -f1`"
else
	dport="$port"
fi

$sudo iptables -t nat -I PREROUTING -p $proto --dport $port -j DNAT --to-destination $daddr:$dport
if [ "$laddr" ]; then
	$sudo iptables -t nat -I POSTROUTING -p $proto -d $daddr --dport $dport -j SNAT --to-source $laddr
else
	$sudo iptables -t nat -I POSTROUTING -p $proto -d $daddr --dport $dport -j MASQUERADE
fi
$sudo iptables -I FORWARD -p $proto -d $daddr --dport $dport -j ACCEPT
$sudo iptables -I FORWARD -p $proto -s $daddr -j ACCEPT




# port-forward.sh port [localaddr]-daddr[:dport]
# port-forward.sh 3080 10.10.1.1-10.10.10.20:80

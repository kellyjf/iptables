#!/bin/bash

#
# Setup Routing tables
#
source defs.sh

for intf in wan1 wan2 ; do
	$ROUTER tc qdisc add dev $intf root handle 1:0 htb default 20
	$ROUTER tc class add dev $intf parent 1:0 classid 1:10 htb rate 2000kbit ceil 2000kbit
	$ROUTER tc class add dev $intf parent 1:0 classid 1:20 htb rate 5000kbit ceil 5000kbit

	$ROUTER tc filter add dev $intf parent 1:0 handle 0x0001/0x00ff fw flowid 1:10
done

$ROUTER iptables -t mangle -A FORWARD -p tcp -m multiport --dports 80,443  \
	-j MARK  --set-mark 0x0001/0x00FF



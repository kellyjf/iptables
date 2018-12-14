#!/bin/bash

#
# Setup Routing tables
#
source defs.sh

perl -i.bak -n -e 'print unless /50[01]\b/' /etc/iproute2/rt_tables

cat >> /etc/iproute2/rt_tables <<!
500 wan1
501 wan2
!


$ROUTER ip route replace ${SUBWAN1}.0/30 dev wan1
$ROUTER ip route replace ${SUBWAN2}.0/30 dev wan2

$ROUTER ip route replace ${SUBWAN1}.0/30 dev wan1 table wan1
$ROUTER ip route replace ${SUBWAN2}.0/30 dev wan2 table wan1
$ROUTER ip route replace default via ${SUBWAN1}.1 table wan1

$ROUTER ip route replace ${SUBWAN1}.0/30 dev wan1 table wan2
$ROUTER ip route replace ${SUBWAN2}.0/30 dev wan2 table wan2
$ROUTER ip route replace default via ${SUBWAN2}.1 table wan2

$ROUTER iptables -t mangle -F
$ROUTER ipset destroy prof1 &> /dev/null
$ROUTER ipset destroy prof2 &> /dev/null

$ROUTER ipset create prof1 hash:ip
$ROUTER ipset create prof2 hash:ip

$ROUTER iptables -t mangle -A PREROUTING -m set --match-set prof1 src \
	-j MARK  --set-mark 0x0100/0xFF00
$ROUTER iptables -t mangle -A PREROUTING -m set --match-set prof2 src \
	-j MARK  --set-mark 0x0200/0xFF00

$ROUTER ip rule flush
$ROUTER ip rule add table local prio 0
$ROUTER ip rule add table main prio 32766 
$ROUTER ip rule add table default prio 32767 
$ROUTER ip rule add fwmark 0x0100/0xff00 table wan1 prio 100
$ROUTER ip rule add fwmark 0x0200/0xff00 table wan2 prio 100


$ROUTER ip rule add fwmark 0x0200/0xff00 table wan2

$ROUTER ipset add prof1 ${SUBLAN}.100
$ROUTER ipset add prof2 ${SUBLAN}.101

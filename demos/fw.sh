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

$ROUTER ip route add ${SUBWAN1}.0/24 dev wan1 table wan1
$ROUTER ip route add ${SUBWAN2}.0/24 dev wan2 table wan1
$ROUTER ip route add default via ${SUBWAN1}.1 table wan1

$ROUTER ip route add ${SUBWAN1}.0/24 dev wan1 table wan2
$ROUTER ip route add ${SUBWAN2}.0/24 dev wan2 table wan2
$ROUTER ip route add default via ${SUBWAN2}.1 table wan2

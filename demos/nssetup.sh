#!/bin/bash

#
# Setup Namespaces, veth links, bridges, ipaddr, routes and NAT
#
source defs.sh

rm -f /var/run/netns/main
ln -s /proc/1/ns/net /var/run/netns/main

for ns in router lan1 lan2; do
	createns $ns
done

for ns in lan1 lan2; do
	linkns router $ns
done

for ns in wan1 wan2; do
	linkns router main $ns $ns
done

$MAIN   ip addr add ${SUBWAN1}.1/30 dev wan1
$MAIN   ip addr add ${SUBWAN2}.1/30 dev wan2
$ROUTER ip addr add ${SUBWAN1}.2/30 dev wan1
$ROUTER ip addr add ${SUBWAN2}.2/30 dev wan2

$ROUTER brctl addbr int-cabin
$ROUTER ip link set int-cabin up
$ROUTER brctl addif int-cabin lan1
$ROUTER brctl addif int-cabin lan2
$ROUTER ip addr add ${SUBLAN}.1/24 dev int-cabin
$ROUTER ip route add default via  ${SUBWAN1}.1
$ROUTER iptables -t nat -A POSTROUTING -o wan1 -j MASQUERADE
$ROUTER iptables -t nat -A POSTROUTING -o wan2 -j MASQUERADE

$LAN1   ip addr add ${SUBLAN}.100/24 dev router
$LAN1   ip route add default via ${SUBLAN}.1
$LAN2   ip addr add ${SUBLAN}.101/24 dev router
$LAN2   ip route add default via ${SUBLAN}.1

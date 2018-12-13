#!/bin/bash


NS="ip netns exec"

function createns {
	ns=$1
	ip netns del $ns
	ip netns add $ns
	ip netns exec $ns ip link set lo up
}

function linkns {
	from=$1
	to=$2
	fromname=$3
	toname=$4

	ip link add t-$to type veth peer name t-$from

	ip link set t-$from netns $to
	$NS $to ip link set t-$from name ${toname:=$from}

	ip link set t-$to netns $from
	$NS $from ip link set t-$to name ${fromname:=$to}

	$NS $to ip link set $toname up
	$NS $from ip link set $fromname up
}

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

$NS main   ip addr add 10.10.100.1/30 dev wan1
$NS main   ip addr add 10.10.200.1/30 dev wan2
$NS router ip addr add 10.10.100.2/30 dev wan1
$NS router ip addr add 10.10.200.2/30 dev wan2

$NS router brctl addbr int-cabin
$NS router ip link set int-cabin up
$NS router brctl addif int-cabin lan1
$NS router brctl addif int-cabin lan2
$NS router ip addr add 10.10.0.1/24 dev int-cabin
$NS router ip route add default via  10.10.100.1
$NS router iptables -t nat -A POSTROUTING -o wan1 -j MASQUERADE
$NS router iptables -t nat -A POSTROUTING -o wan2 -j MASQUERADE


$NS lan1 ip addr add 10.10.0.100/24 dev router
$NS lan1 ip route add default via 10.10.0.1
$NS lan2 ip addr add 10.10.0.101/24 dev router
$NS lan2 ip route add default via 10.10.0.1

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

for ns in router lap1 lap2; do
	createns $ns
done

for ns in lap1 lap2; do
	linkns router $ns
done

for ns in wan1 wan2; do
	linkns router main $ns $ns
done


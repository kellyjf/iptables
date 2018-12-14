#!/bin/bash


NS="ip netns exec"

ROUTER="$NS router"
LAN1="$NS lan1"
LAN2="$NS lan2"
MAIN="$NS main"

RTWAN1=500
RTWAN2=501

SUBLAN="10.10.0"
SUBWAN1="10.10.100"
SUBWAN2="10.10.200"

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


#!/usr/local/bin/bash

set -e

CUSTOM_HOST=132.252.154.84
CUSTOM_TAP="tap7"
VANILLA_HOST=132.252.154.124
VANILLA_TAP="tap8"

function run_experiment {
	host=$1
	tap_interface=$2
	filename=$3
	./set_rtr_mtu.sh 1500

	echo "starting capture"
	tcpdump -i $tap_interface sctp or icmp -w $filename.pcap &
	ssh root@$host "dtrace -s /home/jules/sctp_log_cwnd.d > cwnd_log_$filename.json &" &
	sleep 1
	echo "starting client"
	ssh $host "/remote/projects/trafficgen/tsctp/tsctp -n0 10.23.23.2 &" &
	echo "waiting for experiment to finish"
	sleep 15
	./set_rtr_mtu.sh 1200
	#sleep 15
	#./set_rtr_mtu.sh 1400
	sleep 20
	echo "killing client"
	ssh $host "killall tsctp"
	echo "killing capture"
	killall tcpdump
	ssh root@$host "killall dtrace"
	scp root@$host:/root/cwnd_log_$filename.json .
}

function blackhole_icmp {
	ssh root@rtr1 "ipfw add 42000 reject icmp from any to 10.42.42.2"
	ssh root@rtr1 "ipfw add 42420 reject icmp from any to 10.42.42.3"
}

function reset_firewall {
	ssh root@rtr1 "ipfw delete 42000"
	ssh root@rtr1 "ipfw delete 42000"
}

function configure_bottleneck {
	conf=$1
	echo "Configuring bottleneck to: $1"
	ssh root@rtr1 "ipfw pipe 1 config $conf"
	ssh root@rtr1 "ipfw pipe 2 config $conf"
}

function reset_bottleneck {
	configure_bottleneck "bw 1Gbit/s delay 0ms"
}


configure_bottleneck "bw 10Mbit/s delay 20ms"

run_experiment $CUSTOM_HOST $CUSTOM_TAP "custom"
run_experiment $VANILLA_HOST $VANILLA_TAP "vanilla"

reset_bottleneck

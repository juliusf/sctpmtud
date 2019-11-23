#!/usr/bin/env bash


while true; do
	rsync --progress freebsd-dev-ext:~/dev/sctpmtud/testbed/\*.json data
	for f in ./data/*.json; do
		./plot_cwnd.py $f &
	done
	rsync --progress freebsd-dev-ext:~/dev/sctpmtud/testbed/\*.pcap data
	read -p 'Press Enter to sync and plot again'
done

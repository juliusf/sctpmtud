#!/usr/local/bin/bash

if [ -z "$1" ]
  then
    echo "please specify mtu"
fi

MTU=$1
echo "setting MTU to $MTU"
ssh root@rtr1 "ifconfig vtnet1 10.43.43.1 mtu $MTU && /etc/rc.d/routing restart" > /dev/null
ssh root@rtr2 "ifconfig vtnet1 10.43.43.2 mtu $MTU && /etc/rc.d/routing restart" > /dev/null

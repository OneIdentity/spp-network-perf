#!/bin/bash
IperfPs=$(ps -o pid,args -ef  | grep iperf3 | grep -v grep)
if [ ! -z "$TincdPs" ]; then
    IperfPid=$(echo $IperfPs | cut -d' ' -f1)
    IperfCmd=$(echo $IperfPs | cut -d' ' -f2-)
fi


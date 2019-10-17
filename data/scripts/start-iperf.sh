#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$ScriptDir/utils.sh"
. "$ScriptDir/nodes.sh"

IpV6=$(get_by_index $IpV6List $MyIndex)

iperf3 -s -p 443 -B $IpV6 -I /iperf3.pid --logfile /iperf3.log -D


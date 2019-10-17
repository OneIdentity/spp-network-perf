#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$ScriptDir/utils.sh"
. "$ScriptDir/iperf-data.sh"

if [ -z "$IperfPs" ]; then
    echo -n "null"
else
    echo -n "{\"Pid\":$IperfPid,\"Args\":\"$IperfCmd\"}"
fi


#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$ScriptDir/utils.sh"
. "$ScriptDir/nics-data.sh"

echo -n "["
for nic in "${NicsData[@]}"; do
    echo -n "{\"Name\":\"$(get_by_index $nic 1)\",\"IpAddress\":\"$(get_by_index $nic 2)\",\"IpV6Address\":\"$(get_by_index $nic 3)\"}"
    if [ "$nic" != "${NicsData[-1]}" ]; then
        echo -n ","
    fi
done
echo -n "]"


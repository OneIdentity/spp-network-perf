#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$ScriptDir/utils.sh"
. "$ScriptDir/nodes.sh"

Ip=$(get_by_index $IpList $MyIndex)
IpV6=$(get_by_index $IpV6List $MyIndex)
Int=$(get_by_index $IntList $MyIndex)
PubKey="/keys/rsa${MyIndex}_key.pub"

. "$ScriptDir/tincd-data.sh"
. "$ScriptDir/iperf-data.sh"
. "$ScriptDir/nics-data.sh"

echo -n "{"
echo -n "\"Node\":{\"Id\":$MyIndex,\"Name\":\"$Int\",\"IpAddress\":\"$Ip\",\"VpnAddress\":\"$IpV6\",\"PublicKey\":\"$(sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' $PubKey)\"},"
if [ -z "$TincdPs" ]; then
    echo -n "\"Tincd\":null,"
else
    echo -n "\"Tincd\":{\"Pid\":$TincdPid,\"Args\":\"$TincdCmd\"},"
fi
if [ -z "$IperfPs" ]; then
    echo -n "\"Iperf\":null,"
else
    echo -n "\"Iperf\":{\"Pid\":$IperfPid,\"Args\":\"$IperfCmd\"},"
fi
echo -n "\"Nics\":["
for nic in "${NicsData[@]}"; do
    echo -n "{\"Name\":\"$(get_by_index $nic 1)\",\"IpAddress\":\"$(get_by_index $nic 2)\",\"IpV6Address\":\"$(get_by_index $nic 3)\"}"
    if [ "$nic" != "${NicsData[-1]}" ]; then
        echo -n ","
    fi
done
echo -n "]"
echo -n "}"


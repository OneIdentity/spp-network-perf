#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$ScriptDir/utils.sh"
. "$ScriptDir/nodes.sh"

echo -n "["
count=$(get_count $IpList)
for i in $(seq 1 $count); do
    Ip=$(get_by_index $IpList $i)
    IpV6=$(get_by_index $IpV6List $i)
    Int=$(get_by_index $IntList $i)
    PubKey="/keys/rsa${i}_key.pub"
    echo -n "{\"Id\":$i,\"Name\":\"$Int\",\"IpAddress\":\"$Ip\",\"VpnAddress\":\"$IpV6\",\"PublicKey\":\"$(sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' $PubKey)\"}"
    if [ $i -ne $count ]; then
        echo -n ","
    fi
done
echo -n "]"


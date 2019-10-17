#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$ScriptDir/utils.sh"
. "$ScriptDir/nodes.sh"

i=$1
regex='^[0-9]+$'
if ! [[ "$i" =~ $regex ]] ; then
    >&2 echo "Non-numeric ID provided '$i'"
    exit 1
fi

Ip=$(get_by_index $IpList $i)
IpV6=$(get_by_index $IpV6List $i)
Int=$(get_by_index $IntList $i)
PubKey="/keys/rsa${i}_key.pub"

if [ -z "$Ip" ]; then
    >&2 echo "ID out of range '$i'"
    exit 1
fi

echo -n "{\"Id\":$i,\"Name\":\"$Int\",\"IpAddress\":\"$Ip\",\"VpnAddress\":\"$IpV6\",\"PublicKey\":\"$(sed -E ':a;N;$!ba;s/\r{0,1}\n/\\n/g' $PubKey)\"}"


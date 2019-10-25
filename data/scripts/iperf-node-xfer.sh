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

if [ -z "$Ip" ]; then
    >&2 echo "ID out of range '$i'"
    exit 1
fi

echo "Running iperf xfer against '$Int'"
iperf3 -c $IpV6 -p 443 -6 --connect-timeout 2000 -b 0 -n 1000000000
echo ""


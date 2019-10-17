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

echo "Pinging '$Int'"
ping -c4 $IpV6
echo ""


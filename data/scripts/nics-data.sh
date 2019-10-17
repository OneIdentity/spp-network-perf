#!/bin/bash
ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$ScriptDir/utils.sh"

Nics=$(netstat -i | grep -v Kernel | grep -v Iface | cut -d' ' -f1 | tr '\n' ',')
Nics=${Nics%,}
NicsCount=$(get_count $Nics)
NicsData=()
for i in $(seq 1 $NicsCount); do
    Nic=$(get_by_index $Nics $i)
    IpAddr=$(ifconfig $Nic | awk '/inet addr:/ {print $2}' | sed 's/addr://')
    if [ ! -z "$IpAddr" ]; then
        IpMask=$(ifconfig $Nic | awk '/Mask:/ {print $4}'|sed 's/Mask://')
        IpAddr=$(echo "$IpAddr/$(convert_mask_to_prefix $IpMask)")
    fi
    IpV6Addr=$(ifconfig $Nic | grep Global | awk '/inet6 addr:/ {print $3}')
    NicsData+=($(echo "$Nic,$IpAddr,$IpV6Addr"))
done


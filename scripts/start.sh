#!/bin/bash

check_ip_address()
{
    if ! [[ $1 =~ ^((1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9]{1,2}|2[0-4][0-9]|25[0-5])$ ]]; then
        >&2 echo "'$1' must be a valid IP address"
        exit 1
    fi
}

convert_ip_address_to_int()
{
    local a b c d Ip=$@
    IFS=. read -r a b c d <<<"$Ip"
    printf '%d' "$((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))"
}

convert_int_to_ip_address()
{
    local Delim Exp Oct Ip Int=$@
    for Exp in {3..0}; do
        ((Oct = Int / (256 ** Exp)))
        ((Int -= Oct * 256 ** Exp))
        Ip+=$Delim$Oct
        Delim=.
    done
    printf '%s' "$Ip"
}

sort_ip_list()
{
    local TempList IntList Ip Int
    for Ip in $(echo $1 | sed "s/,/ /g"); do
        IntList+="$(convert_ip_address_to_int $Ip),"
    done
    IntList=${IntList%,}
    IntList=$(echo $IntList | tr ',' '\n' | sort | tr '\n' ',');
    IntList=${IntList%,}
    for Int in $(echo $IntList | sed "s/,/ /g"); do
        TempList+="$(convert_int_to_ip_address $Int),"
    done
    TempList=${TempList%,}
    TempList=$(echo $TempList | sort | tr '\n' ',');
    echo ${TempList%,}
}


# Main script
echo "Checking for environment information"
if [ -z "$LOCAL_IP" -o -z "$PEER_IPS" ]; then
    >&2 cat <<EOF
Not all environment variables are set:
    LOCAL_IP=$LOCAL_IP
    PEER_IPS=$PEER_IPS
EOF
    if [ -z "$LOCAL_IP" ]; then
        read -p "Local IP address: " LOCAL_IP
    fi
    if [ -z "$PEER_IPS" ]; then
        read -p "Peer IP addresses (comma-delimited): " PEER_IPS
    fi
fi

echo "Validating inputs"
IpList="$LOCAL_IP"
check_ip_address $LOCAL_IP
for Ip in $(echo $PEER_IPS | sed "s/,/ /g"); do
    check_ip_address $Ip
    if [ "$LOCAL_IP" = "$Ip" ]; then
        >&2 echo "Peer IP '$Ip' is the same as local IP '$LOCAL_IP'"
        exit 1
    fi
    IpList=$(echo "$IpList,$Ip")
done
IpList=$(sort_ip_list $IpList)

if test -t 1; then
    YELLOW='\033[1;33m'
    NC='\033[0m'
fi

# Get the directory of this script while executing
ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo -e "${YELLOW}Setting up tinc.conf and keys${NC}"


echo -e "${YELLOW}Starting tincd${NC}"


echo -e "${YELLOW}Starting iperf server on VPN interface on TCP port 443${NC}"


echo -e "${YELLOW}Starting the web service on port 8080${NC}"
cd /service && npm run start


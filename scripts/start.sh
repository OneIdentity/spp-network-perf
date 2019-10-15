#!/bin/bash

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
cd /scripts && npm run start


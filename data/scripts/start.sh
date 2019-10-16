#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$ScriptDir/utils.sh"

# Main script
if test -t 1; then
    YELLOW='\033[1;33m'
    NC='\033[0m'
fi


echo -e "${YELLOW}Checking for environment information${NC}"
if [ -z "$LOCAL_IP" -o -z "$PEER_IPS" -o -z "$PMTU" ]; then
    >&2 cat <<EOF
Not all environment variables are set:
    LOCAL_IP=$LOCAL_IP
    PEER_IPS=$PEER_IPS
    PMTU=$PMTU
EOF
    # Prompt for missing required inputs
    if [ -z "$LOCAL_IP" ]; then
        read -p "Local IP address: " LOCAL_IP
    fi
    if [ -z "$PEER_IPS" ]; then
        read -p "Peer IP addresses (comma-delimited): " PEER_IPS
    fi
fi


echo -e "${YELLOW}Validating inputs${NC}"
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
# Generated sorted list of IP addresses and VPN IPv6 addresses
IpList=$(sort_ip_list $IpList)
for Ip in $(echo $IpList | sed "s/,/ /g"); do
    IpV6List=$(echo "$IpV6List$(generate_ipv6_address $Ip),")
done
IpV6List=${IpV6List%,}


echo -e "${YELLOW}Setting up tinc.conf, hosts, and keys${NC}"

for i in $(seq 1 $(get_count $IpList)); do
    Ip=$(get_by_index $IpList $i)
    IpV6=$(get_by_index $IpV6List $i)
    Int=$(convert_ip_address_to_int $Ip)
    PubKey="/keys/rsa${i}_key.pub"
    if [ "$Ip" = "$LOCAL_IP" ]; then
        # Generate tinc.conf
        cat <<EOF > /etc/tinc/tinc.conf
Name = $Int
PrivateKeyFile = /keys/rsa${i}_key.priv
Mode = router
Interface = tun0
AddressFamily = ipv6
EOF
        # Generate tinc-up and tinc-down
        cat <<EOF > /etc/tinc/tinc-up
#!/bin/bash
ip link set \$INTERFACE up
ip addr add $IpV6/64 dev \$INTERFACE
EOF
        cat <<EOF > /etc/tinc/tinc-down
#!/bin/bash
ip link set \$INTERFACE down
EOF
        chmod 755 /etc/tinc/tinc-*
    fi
    # Generate host file for node
    cat <<EOF > /etc/tinc/hosts/$Int
Address = $Ip
Subnet = $IpV6/128
$(cat $PubKey)
EOF
done

echo -e "${YELLOW}Starting tincd${NC}"
mkdir -p /dev/net
mknod /dev/net/tun c 10 200
chmod 600 /dev/net/tun


echo -e "${YELLOW}Starting iperf server on VPN interface on TCP port 443${NC}"


echo -e "${YELLOW}Starting the web service on port 8080${NC}"
cd /service && npm run start


#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ContainerName=spp-network-perf-runtime
Command=

print_usage()
{
    cat <<EOF
USAGE: client.sh [-h] [-c command [arg]]

  -h  Show help and exit
  -c  Run command against a running container
      commands:
      status      Get information about the running service
      nodes       List all of the configured nodes
      ping [ip]   Run a ping test against the target IP
      iperf [ip]  Run an iperf test against the target IP
      stats       Tell tincd to write statistics to its log
      logs        Download logs from iperf server and tincd

EOF
    exit 0
}

while getopts ":hc:" opt; do
    case $opt in
    h)
        print_usage
        ;;
    c)
        Command=$OPTARG
        shift; shift;
        ;;
    ?)
        break
        ;;
    esac
done

if test -t 1; then
    YELLOW='\033[1;33m'
    NC='\033[0m'
fi

# Make sure docker and other tools are installed
if [ -z "$(which docker)" ]; then
    >&2 echo "You must install docker to use this script"
    exit 1
fi
if [ -z "$(which tr)" ]; then
    >&2 echo "You must install tr to use this script"
    exit 1
fi
if [ -z "$(which curl)" ]; then
    >&2 echo "You must install curl to use this script"
    exit 1
fi
JQ=jq
if [ -z "$(which jq)" ]; then
    if [ ! -x "$ScriptDir/tmp/jq" ]; then
        echo -e "${YELLOW}Downloading jq${NC}"
        mkdir -p $ScriptDir/tmp 2> /dev/null
        curl -o $ScriptDir/tmp/jq -L "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
        chmod +x $ScriptDir/tmp/jq
        echo -e "${YELLOW}Continuing${NC}"
    fi
    JQ=$ScriptDir/tmp/jq
fi

# Check if spp-network-perf-runtime is running
docker ps | grep spp-network-perf-runtime > /dev/null
if [ $? -ne 0 ]; then
   >&2 echo "The container is not running"
   exit 1
fi

# Gather IP address information (only supports IPv4)
. $ScriptDir/data/scripts/utils.sh
if [ "$(uname)" = "Darwin" ]; then
    IpAddress=$(ifconfig | grep inet | grep -v inet6 | cut -d' ' -f2 | tr '\n' ',')
else
    IpAddress=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p' | tr '\n' ',')
fi
IpAddress=${IpAddress%,}
if [ -z "$IpAddress" ]; then
    read -p "Local IP Address: " IpAddress
elif [ $(echo $IpAddress | awk -F',' '{print NF}') -gt 1 ]; then
    read -p "Local IP Address ($IpAddress): " IpAddress
else
    echo "Local IP Address: $IpAddress"
fi
check_ip_address $IpAddress

# Handle args
if [ -z "$Command" ]; then
    >&2 echo "Please specify a command"
    print_usage
fi
UCommand=$(echo "$Command" | tr '[:lower:]' '[:upper:]')
case $UCommand in
    STATUS)
        curl -s http://$IpAddress:8080/me | $JQ .
        ;;
    NODES)
        curl -s http://$IpAddress:8080/nodes | $JQ .
        ;;
    PING)
        TargetIp=$1
        check_ip_address $TargetIp
        NodeId=$(curl -s http://$IpAddress:8080/nodes | $JQ -r ".[] | select( .IpAddress == \"$TargetIp\" ) | .Id")
        if [ -z "$NodeId" ]; then
            >&2 echo "Unable to find node ID for $TargetIp"
            exit
        fi
        curl -s -X POST http://$IpAddress:8080/nodes/$NodeId/ping
        ;;
    IPERF)
        TargetIp=$1
        check_ip_address $TargetIp
        NodeId=$(curl -s http://$IpAddress:8080/nodes | $JQ -r ".[] | select( .IpAddress == \"$TargetIp\" ) | .Id")
        if [ -z "$NodeId" ]; then
            >&2 echo "Unable to find node ID for $TargetIp"
            exit
        fi
        echo "Patience, this test takes 20 seconds"
        curl -s -X POST http://$IpAddress:8080/nodes/$NodeId/iperf
        ;;
    XFER)
        TargetIp=$1
        check_ip_address $TargetIp
        NodeId=$(curl -s http://$IpAddress:8080/nodes | $JQ -r ".[] | select( .IpAddress == \"$TargetIp\" ) | .Id")
        if [ -z "$NodeId" ]; then
            >&2 echo "Unable to find node ID for $TargetIp"
            exit
        fi
        echo "Patience, this test may take a while...transferring 1 GB"
        curl -s -X POST http://$IpAddress:8080/nodes/$NodeId/xfer
        ;;
    STATS)
        curl -X POST http://$IpAddress:8080/me/tincd/stats
        ;;
    LOGS)
        mkdir -p "$ScriptDir/tmp" 2> /dev/null
        TincdFile="$ScriptDir/tmp/tincd-$(date +%Y-%m-%d-%H-%M-%S).log"
        IperfFile="$ScriptDir/tmp/iperf-$(date +%Y-%m-%d-%H-%M-%S).log"
        curl -o $TincdFile http://$IpAddress:8080/me/tincd/log
        curl -o $IperfFile http://$IpAddress:8080/me/iperf/log
        echo "tincd.log written to '$TincdFile'"
        echo "iperf.log written to '$IperfFile'"
        ;;
    *)
        >&2 echo "Unknown command '$Command', Please specify a valid command"
        print_usage
        ;;
esac


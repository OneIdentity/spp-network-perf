#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

print_usage()
{
    cat <<EOF
USAGE: run-service.sh [-h] [-c command]

  -h  Show help and exit
  -c  Alternate command to run in the container (-c /bin/bash to get a prompt)
      Always specify the -c option last

EOF
    exit 0
}

while getopts ":h" opt; do
    case $opt in
    h)
        print_usage
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

# not sure this command will work on Mac
if [ "$(uname)" = "Darwin" ]; then
    IpAddress=$(ifconfig | grep inet | grep -v inet6 | cut -d' ' -f2 | tr '\n' ',')
else
    IpAddress=$(ip -o route get to 8.8.8.8 | sed -n 's/.*src \([0-9.]\+\).*/\1/p' | tr '\n' ',')
fi
IpAddress=${IpAddress%,}

if [ $(echo $IpAddress | awk -F',' '{print NF}') -gt 1 ]; then
    read -p "IP Address ($IpAddress): " IpAddress
fi

if [ ! -z "$(which docker)" ]; then
    docker images | grep spp-network-perf
    if [ $? -ne 0 ]; then
        $ScriptDir/build.sh
    fi
    echo -e "${YELLOW}Running the spp-network-perf container with IP Address: $IpAddress${NC}"
    docker run -p $IpAddress:8080:8080 -p $IpAddress:655:655 -p $IpAddress:655:655/udp --env-file <(echo "LOCAL_IP=$IpAddress") -it spp-network-perf "$@"
else
    >&2 echo "You must install docker to use this script"
fi


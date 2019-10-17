#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ContainerName=spp-network-perf-runtime

print_usage()
{
    cat <<EOF
USAGE: stop-service.sh [-h]

  -h  Show help and exit

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

# Make sure docker is installed
if [ -z "$(which docker)" ]; then
    >&2 echo "You must install docker to use this script"
    exit 1
fi

# Stop spp-network-perf-runtime if running
docker ps | grep spp-network-perf-runtime
if [ $? -ne 0 ]; then
   >&2 echo "The container is not running"
   exit 1
else
   echo -e "${YELLOW}Stopping container"
   docker stop -t 5 $ContainerName
fi


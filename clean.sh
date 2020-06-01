#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ImageName=spp-network-perf
ContainerName=spp-network-perf-runtime

print_usage()
{
    cat <<EOF
USAGE: clean.sh [-h]

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


# Check to see if the container is running and stop it
docker ps | grep $ContainerName
if [ $? -eq 0 ]; then
    $ScriptDir/stop-service.sh
fi

# Clean up any old container with that name
docker ps -a | grep $ContainerName
if [ $? -eq 0 ]; then
    docker rm $ContainerName
fi

# Remove the image
docker rmi $ImageName


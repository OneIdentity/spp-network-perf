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

if [ ! -z "$(which docker)" ]; then
    docker images | grep safeguard-bash
    if [ $? -ne 0 ]; then
        $ScriptDir/build.sh
    fi
    echo -e "${YELLOW}Running the spp-network-perf container.\n" \
            "You can specify an alternate startup command using arguments to this script.\n" \
            "The default entrypoint is bash, so use the -c argument.\n" \
            "  e.g. run-service.sh -c /bin/bash${NC}"
    docker run -it spp-network-perf "$@"
else
    >&2 echo "You must install docker to use this script"
fi


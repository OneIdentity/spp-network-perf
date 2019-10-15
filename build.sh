#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ ! -z "$(which docker)" ]; then
    docker build -t spp-network-perf $ScriptDir
else
    >&2 echo "You must install docker to use this build script"
fi


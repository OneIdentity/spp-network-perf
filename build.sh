#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ImageName=spp-network-perf

if [ ! -z "$(which docker)" ]; then
    docker build -t $ImageName $ScriptDir
else
    >&2 echo "You must install docker to use this build script"
fi


#!/bin/bash

ScriptDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$ScriptDir/utils.sh"
. "$ScriptDir/tincd-data.sh"

if [ -z "$TincdPs" ]; then
    echo -n "null"
else
    echo -n "{\"Pid\":$TincdPid,\"Args\":\"$TincdCmd\"}"
fi


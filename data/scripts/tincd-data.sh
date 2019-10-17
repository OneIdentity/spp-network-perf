#!/bin/bash
TincdPs=$(ps -o pid,args -ef  | grep "tincd --pidfile" | grep -v grep)
if [ ! -z "$TincdPs" ]; then
    TincdPid=$(echo $TincdPs | cut -d' ' -f1)
    TincdCmd=$(echo $TincdPs | cut -d' ' -f2-)
fi


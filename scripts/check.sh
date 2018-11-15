#!/usr/bin/env bash

set -eo pipefail

function check_dependencies() {

    DEPENDENCIES="docker helm kubectl"

    for i in $DEPENDENCIES
    do
        type -P $i &>/dev/null  && continue  || { echo "Error: Please install $i"; exit 1; }
    done;
}

function check_ports() {

    PORTS="9030 9060 9090 80 8000"

    for p in $PORTS
    do
        if [ $(lsof -PiTCP -sTCP:LISTEN | grep localhost | awk '{print $9}' | grep $p | wc -l) != 0 ];
           then
               echo "error: you must release the port $p"
               exit 1
           fi;
    done;
}

(check_dependencies)
(check_ports)

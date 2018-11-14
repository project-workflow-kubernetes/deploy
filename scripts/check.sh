#!/usr/bin/env bash

set -eo pipefail

function check_dependencies() {

    DEPENDENCIES="docker helm kubectl mc"

    for i in $DEPENDENCIES
    do
        type -P $i &>/dev/null  && continue  || { echo "Error: Please install $i"; exit 1; }
    done;
}

function check_ports() {
    exit 0
}

(check_dependencies)
(check_ports)

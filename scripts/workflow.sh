#!/usr/bin/env bash

set -eo pipefail


function up () {

    helm install --name workflow --namespace workflow configs/workflow/

}


function down () {

    helm init
    helm del --purge workflow

}


case "$1" in
  (up)
    up
    exit 0
    ;;
  (down)
      down
    exit 0
    ;;
  (*)
    echo "Usage: $0 { up | down }"
    exit 2
    ;;
esac

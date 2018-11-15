#!/usr/bin/env bash

set -eo pipefail


function up () {

    kubectl create namespace workflow
    kubectl create namespace argo

}


function down () {

    kubectl delete namespace workflow
    kubectl delete namespace argo

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

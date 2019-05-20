#!/usr/bin/env bash

set -eo pipefail


function up () {

    helm init --upgrade
    sleep 5

    kubectl create namespace workflow
    kubectl create namespace argo
    kubectl create namespace redis

}


function down () {

    kubectl delete namespace workflow
    kubectl delete namespace argo
    kubectl delete namespace redis

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

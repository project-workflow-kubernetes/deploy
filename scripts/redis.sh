#!/usr/bin/env bash

set -eo pipefail


function up () {
  kubectl -n redis apply -f configs/redis-master-deployment.yaml
  kubectl -n redis apply -f configs/redis-master-service.yaml
}


function down () {
  kubectl delete -n redis deployment -l app=redis
  kubectl delete -n redis service -l app=redis
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

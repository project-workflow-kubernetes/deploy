#!/usr/bin/env bash

set -eo pipefail


function up () {

    helm install --name workflow --namespace workflow configs/workflow/
    kubectl -n workflow create clusterrolebinding workflow --clusterrole cluster-admin --serviceaccount workflow:default || true

}


function down () {

    helm init
    helm del --purge workflow
    kubectl delete -n workflow clusterrolebinding workflow || true

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

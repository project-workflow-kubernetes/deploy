#!/usr/bin/env bash

set -eo pipefail


function up () {

    kubectl create -f configs/workflow.yaml --namespace workflow

    echo "warning: waiting until service is ready"

    sleep 10 # TODO: improve it

    kubectl port-forward workflow-0 8000:8000 --namespace workflow 1>/dev/null 2>&1 & # TODO: improve it to have a LoadBalancer

    echo ""

}


function down () {

    kubectl delete --all pods --namespace=workflow
    kubectl delete statefulset workflow -n workflow
    kubectl delete service workflow-service --namespace workflow

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

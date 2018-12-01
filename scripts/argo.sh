#!/usr/bin/env bash

set -eo pipefail


function up () {

    helm init
    helm repo add argo https://argoproj.github.io/argo-helm
    helm install --name argo \
                 --namespace argo \
                 -f configs/argo.yaml \
                 argo/argo

}


function down () {

    helm init
    helm del --purge argo
    kubectl delete customresourcedefinitions workflows.argoproj.io # so annoying

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

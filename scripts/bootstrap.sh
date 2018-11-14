#!/usr/bin/env bash

set -eo pipefail

function check_dependencies() {

    DEPENDENCIES="docker helm kubectl mc"

    for i in $DEPENDENCIES
    do
        type -P $i &>/dev/null  && continue  || { echo "Error: Please install $i"; exit 1; }
    done;
}


function up () {
    (check_dependencies)

    helm init

    kubectl create namespace storage-temporary
    kubectl create namespace storage-persistent
    kubectl create namespace argo

    helm install --name minio-tmp \
                 --namespace storage-temporary \
                 -f configs/minio-temporary.yaml \
                 stable/minio

    helm install --name minio \
                 --namespace storage-persistent \
                 -f configs/minio-persistent.yaml \
                 stable/minio

    helm repo add argo https://argoproj.github.io/argo-helm
    helm install --name argo \
                 --namespace argo \
                 -f configs/argo.yaml \
                 argo/argo

    sleep 5
    export POD_NAME=$(kubectl get pods --namespace storage-temporary -l "release=minio-tmp" \
                              -o jsonpath="{.items[0].metadata.name}")
    kubectl port-forward $POD_NAME 9060:9000 --namespace storage-temporary 1>/dev/null 2>&1 &
    sleep 5
    export POD_NAME=$(kubectl get pods --namespace storage-persistent -l "release=minio" \
                              -o jsonpath="{.items[0].metadata.name}")
    kubectl port-forward $POD_NAME 9090:9000 --namespace storage-persistent 1>/dev/null 2>&1 &
    sleep 5

    echo ""
}


function down () {
    (check_dependencies)

    pkill -f port-forward || true

    # helm del --purge nginx-ingress
    helm del --purge minio-tmp
    helm del --purge minio
    helm del --purge argo

    kubectl delete namespace storage-temporary
    kubectl delete namespace storage-persistent
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

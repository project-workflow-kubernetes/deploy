#!/usr/bin/env bash

set -eo pipefail

MINIO_ACCESS_KEY=minio
MINIO_SECRET_KEY=minio1234
IP=localhost


function up () {

    helm init

    helm install --name minio-tmp \
                 --namespace  workflow \
                 -f configs/minio-temporary.yaml \
                 stable/minio

    helm install --name minio \
                 --namespace workflow \
                 -f configs/minio-persistent.yaml \
                 stable/minio


    # echo "warning: ports might take some time to be mapped..."
    # sleep 25 # improve it

    # export POD_NAME=$(kubectl get pods --namespace workflow -l "release=minio-tmp" \
    #                           -o jsonpath="{.items[0].metadata.name}")
    # kubectl port-forward $POD_NAME 9030:9000 --namespace workflow 1>/dev/null 2>&1 &

    # export POD_NAME=$(kubectl get pods --namespace workflow -l "release=minio" \
    #                           -o jsonpath="{.items[0].metadata.name}")
    # kubectl port-forward $POD_NAME 9060:9000 --namespace workflow 1>/dev/null 2>&1 &

    # sleep 10

}


function down () {

    pkill -f port-forward || true # TODO: find a better way to do it

    helm init
    helm del --purge minio-tmp
    helm del --purge minio

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

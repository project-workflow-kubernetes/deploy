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

}


function expose () {

    PORTS="9030 9060"

    for p in $PORTS
    do
        if [ $(lsof -PiTCP -sTCP:LISTEN | grep localhost | awk '{print $9}' | grep localhost:$p | wc -l) != 0 ];
           then
               echo "error: you must release the port $p"
               exit 1
           fi;
    done;


    export POD_NAME=$(kubectl get pods --namespace workflow -l "release=minio-tmp" \
                               -o jsonpath="{.items[0].metadata.name}")
    kubectl port-forward $POD_NAME 9030:9000 --namespace workflow 1>/dev/null 2>&1 &

    export POD_NAME=$(kubectl get pods --namespace workflow -l "release=minio" \
                               -o jsonpath="{.items[0].metadata.name}")
    kubectl port-forward $POD_NAME 9060:9000 --namespace workflow 1>/dev/null 2>&1 &

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
  (expose)
      expose
    exit 0
    ;;
  (*)
    echo "Usage: $0 { up | expose | down }"
    exit 2
    ;;
esac

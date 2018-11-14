#!/usr/bin/env bash

# set -eo pipefail

MINIO_ACCESS_KEY=minio
MINIO_SECRET_KEY=minio1234
IP=localhost


function up () {
    helm init

    kubectl create namespace storage-temporary
    kubectl create namespace storage-persistent
    kubectl create namespace storage-workflow

    helm install --name minio-tmp \
                 --namespace storage-temporary \
                 -f configs/minio-temporary.yaml \
                 stable/minio

    helm install --name minio \
                 --namespace storage-persistent \
                 -f configs/minio-persistent.yaml \
                 stable/minio

     helm install --name minio-workflow \
                 --namespace storage-workflow \
                 -f configs/minio-workflow.yaml \
                 stable/minio


    sleep 20
    echo "Warning: ports might take some time to open..."
    export POD_NAME=$(kubectl get pods --namespace storage-temporary -l "release=minio-tmp" \
                              -o jsonpath="{.items[0].metadata.name}")
    kubectl port-forward $POD_NAME 9030:9000 --namespace storage-temporary 1>/dev/null 2>&1 &
    export POD_NAME=$(kubectl get pods --namespace storage-persistent -l "release=minio" \
                              -o jsonpath="{.items[0].metadata.name}")
    kubectl port-forward $POD_NAME 9060:9000 --namespace storage-persistent 1>/dev/null 2>&1 &
    export POD_NAME=$(kubectl get pods --namespace storage-workflow -l "release=minio-workflow" \
                               -o jsonpath="{.items[0].metadata.name}")
    kubectl port-forward $POD_NAME 9090:9000 --namespace storage-workflow 1>/dev/null 2>&1 &

    sleep 10

    mc config host add s3tmp http://${IP}:9030 ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY}
    mc config host add s3fixed http://${IP}:9060 ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY}
    mc config host add s3workflow http://${IP}:9090 ${MINIO_ACCESS_KEY} ${MINIO_SECRET_KEY}
}


function down () {
    pkill -f port-forward || true # TODO: find a better way to do it

    mc config host remove s3tmp
    mc config host remove s3fixed
    mc config host remove s3workflow

    helm del --purge minio-tmp
    helm del --purge minio
    helm del --purge minio-workflow

    kubectl delete namespace storage-temporary
    kubectl delete namespace storage-persistent
    kubectl delete namespace storage-workflow
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

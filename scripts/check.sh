#!/usr/bin/env bash

set -eo pipefail


function check-dependencies() {

    DEPENDENCIES="kubectl helm"

    for i in $DEPENDENCIES
    do
        type -P $i &>/dev/null && \
            echo
            echo $($i version) && \
            continue  || { echo "Error: Please install $i"; exit 1; }
    done;

    echo
    echo "All required dependencies are installed :)"

}


function check-cluster() {

    kubectl cluster-info
    helm init --upgrade
    sleep 10
    helm install -n test --namespace test stable/nginx-ingress

    if [[ $(kubectl config view | grep current-context | awk '{ print $2 }') = "minikube" ]];
    then
        URL=$(minikube service -n test test-nginx-ingress-controller --url | head -n 1)
    else
        URL=http://localhost
    fi;

    echo "Waiting for the NGINX Ingress"
    sleep 60
    curl ${URL} &>/dev/null \
            || { echo "Error: Timeout, check cluster connections"; helm del --purge test; exit 1; }

    helm del --purge test
    kubectl delete namespace test

    echo
    echo "The Kubernetes cluster is ready \o/"

}


function check-ports() {

    PORTS="80 8000"

    for p in $PORTS
    do
        if [ $(lsof -PiTCP -sTCP:LISTEN | grep localhost | awk '{print $9}' | grep localhost:$p | wc -l) != 0 ];
           then
               echo "error: you must release the port $p"
               exit 1
           fi;
    done;

}


case "$1" in
  (check-dependencies)
      check-dependencies
    exit 0
    ;;
  (check-cluster)
      check-cluster
    exit 0
    ;;
  (check-ports)
      check-ports
    exit 0
    ;;
  (*)
    echo "Usage: $0 { check-dependencies | check-cluster | check-ports }"
    exit 2
    ;;
esac

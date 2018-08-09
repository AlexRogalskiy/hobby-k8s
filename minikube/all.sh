#!/bin/bash

print_banner () {
    echo "***************************************************"
    echo $1
    echo "***************************************************"
}

mkdir ./tmp

if minikube status|grep 'cluster: Running' > /dev/null; then
    echo "Minikube already running"
else
    print_banner "Starting Minikube"
    minikube start
fi

kubectl config use-context minikube

print_banner "Initialising Helm / installing Tiller"
helm init

print_banner "Installing Traefik Ingress"
kubectl apply -f traefik/traefik-rbac.yaml
kubectl apply -f traefik/traefik-ds.yaml

print_banner "Installing Traefik UI"
kubectl apply -f traefik/traefik-ui.yaml

print_banner "Installing cheeses"
helm install charts/cheese --set cheese=stilton -n cheese-stilton
helm install charts/cheese --set cheese=cheddar -n cheese-cheddar
helm install charts/cheese --set cheese=wensleydale -n cheese-wensleydale

print_banner "Cleaning up"

rm -rf ./tmp

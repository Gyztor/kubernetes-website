#!/bin/bash

#helm repo add bitnami https://charts.bitnami.com/bitnami
#helm repo update
helm dependency update
sleep 5
kubectl create namespace <namespace-name>
sleep 5
helm install <releasename> ./ --namespace <namespace>

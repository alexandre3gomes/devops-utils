#!/bin/sh
cd ../kubernetes/
kubectl create -f local-dep.yaml
kubectl create -f deploy-api.yaml
kubectl create -f deploy-web.yaml
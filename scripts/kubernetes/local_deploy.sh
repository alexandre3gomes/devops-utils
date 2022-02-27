#!/bin/sh
cd ../kubernetes/
kubectl create -f local_dep.yaml
kubectl create -f deploy_api.yaml
kubectl create -f deploy_web.yaml
#!/bin/sh
kubectl apply --kustomize github.com/kubernetes/ingress-nginx/deploy/prometheus/
kubectl apply --kustomize github.com/kubernetes/ingress-nginx/deploy/grafana/
kubectl delete -n ingress-nginx configmap prometheus-configuration-bc6bcg7b65
kubectl create -f ../kubernetes/prometheus-cm.yaml
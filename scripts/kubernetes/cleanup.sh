#!/bin/sh
kubectl delete deploy finances-easy-api
kubectl delete deploy finances-easy-web
kubectl delete secret finances-easy-api-secret
kubectl delete svc finances-easy-api-svc
kubectl delete svc finances-easy-web-svc
kubectl delete ingress finances-easy-api-ingress
kubectl delete ingress finances-easy-web-ingress
kubectl delete -n ingress-nginx deploy grafana
kubectl delete -n ingress-nginx deploy prometheus-server
kubectl delete -n ingress-nginx svc grafana
kubectl delete -n ingress-nginx svc prometheus-server
kubectl delete -n ingress-nginx configmap prometheus-configuration-bc6bcg7b65
kubectl delete -n ingress-nginx rolebinding prometheus-server
kubectl delete -n ingress-nginx role prometheus-server
kubectl delete -n ingress-nginx serviceaccount prometheus-server
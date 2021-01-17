#!/bin/sh
kubectl delete deploy finances-easy-api
kubectl delete deploy finances-easy-web
kubectl delete secret finances-easy-api-secret
kubectl delete svc finances-easy-api-svc
kubectl delete svc finances-easy-web-svc
kubectl delete ingress finances-easy-api-ingress
kubectl delete ingress finances-easy-api-ingress
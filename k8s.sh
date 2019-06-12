#!/bin/bash
kubectl create configmap kongconfig --from-file=conf.d
kubectl apply -f ./pod.yaml
kubectl apply -f ./svc.yaml

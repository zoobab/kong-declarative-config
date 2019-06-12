#!/bin/bash
microk8s.kubectl create configmap kongconfig --from-file=conf.d
microk8s.kubectl apply -f ./pod.yaml
microk8s.kubectl apply -f ./svc.yaml

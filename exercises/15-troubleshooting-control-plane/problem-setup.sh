#!/usr/bin/env bash

sudo sed -i 's/authentication-kubeconfig=\/etc\/kubernetes\/scheduler.conf/authentication-kubeconfig=\/etc\/kubernetes\/scheduler-authentication.conf/g' /etc/kubernetes/manifests/kube-scheduler.yaml
kubectl create deployment deploy --image=nginx --replicas=3
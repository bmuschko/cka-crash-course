#!/usr/bin/env bash

# Misconfigures a setting of the Kubernetes scheduler Pod
sudo sed -i 's/authentication-kubeconfig=\/etc\/kubernetes\/scheduler.conf/authentication-kubeconfig=\/etc\/kubernetes\/scheduler-authentication.conf/g' /etc/kubernetes/manifests/kube-scheduler.yaml

# Schedule a Deployment with three replicas
kubectl create deployment deploy --image=nginx --replicas=3
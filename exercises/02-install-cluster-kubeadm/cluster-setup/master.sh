#!/usr/bin/env bash

POD_CIDR=$1
API_ADV_ADDRESS=$2

kubeadm init --pod-network-cidr $POD_CIDR --apiserver-advertise-address $API_ADV_ADDRESS | tee /vagrant/kubeadm-init.out

mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown vagrant:vagrant $HOME/.kube/config
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config

wget -q https://docs.projectcalico.org/v3.10/manifests/calico.yaml -O /tmp/calico-default.yaml
sed "s+192.168.0.0/16+$POD_CIDR+g" /tmp/calico-default.yaml > /tmp/calico-defined.yaml

kubectl apply -f /tmp/calico-defined.yaml
rm /tmp/calico-default.yaml /tmp/calico-defined.yaml
echo KUBELET_EXTRA_ARGS=--node-ip=10.8.8.10 > /etc/default/kubelet
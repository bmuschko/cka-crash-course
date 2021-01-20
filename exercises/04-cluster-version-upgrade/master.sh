#!/usr/bin/env bash

POD_CIDR=$1
API_ADV_ADDRESS=$2

kubeadm init --pod-network-cidr $POD_CIDR --apiserver-advertise-address $API_ADV_ADDRESS | tee /vagrant/kubeadm-init.out

mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config

kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml

cp /etc/kubernetes/admin.conf /vagrant/admin.conf
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

# Install etcdctl
ETCD_VERSION="v3.4.14"
wget https://github.com/etcd-io/etcd/releases/download/$ETCD_VERSION/etcd-$ETCD_VERSION-linux-amd64.tar.gz -O /tmp/etcd-$ETCD_VERSION-linux-amd64.tar.gz
tar xvf /tmp/etcd-$ETCD_VERSION-linux-amd64.tar.gz -C /tmp
sudo mv /tmp/etcd-$ETCD_VERSION-linux-amd64/etcd /tmp/etcd-$ETCD_VERSION-linux-amd64/etcdctl /usr/local/bin
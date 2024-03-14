#!/usr/bin/env bash

POD_CIDR=$1
API_ADV_ADDRESS=$2

kubeadm init --pod-network-cidr $POD_CIDR --apiserver-advertise-address $API_ADV_ADDRESS | tee /vagrant/kubeadm-init.out

systemctl daemon-reload
echo "KUBELET_EXTRA_ARGS=--node-ip=$API_ADV_ADDRESS --cgroup-driver=systemd" > /etc/default/kubelet
systemctl restart kubelet

mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown vagrant:vagrant /home/vagrant/.kube/config
mkdir -p /root/.kube
cp -i /etc/kubernetes/admin.conf /root/.kube/config

kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/tigera-operator.yaml
wget https://raw.githubusercontent.com/projectcalico/calico/v3.27.2/manifests/custom-resources.yaml
sed -i 's~cidr: 192\.168\.0\.0/16~cidr: 172\.18\.0\.0/16~g' custom-resources.yaml
kubectl create -f custom-resources.yaml
rm custom-resources.yaml

cp /etc/kubernetes/admin.conf /vagrant/admin.conf
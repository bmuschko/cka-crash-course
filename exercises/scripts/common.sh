#!/usr/bin/env bash

if [ -z ${K8S_VERSION+x} ]; then
  K8S_VERSION=1.26.1-1.1
fi

# Install containerd container runtime
sudo apt install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install containerd.io
sudo systemctl start containerd
sudo systemctl enable containerd
sudo systemctl status containerd
sudo mv etc/containerd/config.toml etc/containerd/config.toml.orig
containerd config default | sudo tee /etc/containerd/config.toml
sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz
mkdir -p /opt/cni/bin
tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz
sudo systemctl restart containerd

sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSL "https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION:0:4}/deb/Release.key" | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_VERSION:0:4}/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install Kubernetes binaries
sudo apt-get update
sudo apt-get install -y \
  kubeadm=$K8S_VERSION \
  kubelet=$K8S_VERSION \
  kubectl=$K8S_VERSION
sudo apt-mark hold kubelet kubeadm kubectl

# Required for kubeadm preinstall checks
modprobe br_netfilter
echo '1' > /proc/sys/net/ipv4/ip_forward

# Set alias for kubectl command
echo "alias k=kubectl" >> /home/vagrant/.bashrc
#!/usr/bin/env bash

if [ -z ${K8S_VERSION+x} ]; then
  K8S_VERSION=1.23.4-00
fi

apt-get update && apt-get install \
apt-transport-https \
ca-certificates \
curl \
software-properties-common \
gnupg \
lsb-release

# Google Cloud public signing key
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
# Add the Kubernetes repository
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Add Docker’s official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
# Set up docker repository
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
 $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get update
apt-get install -y \
avahi-daemon \
libnss-mdns \
traceroute \
htop \
httpie \
bash-completion \
docker-ce \
docker-ce-cli \
containerd.io \
docker-compose-plugin \
kubeadm=$K8S_VERSION \
kubelet=$K8S_VERSION \
kubectl=$K8S_VERSION

cat > /etc/docker/daemon.json <<EOF
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

mkdir -p /etc/systemd/system/docker.service.d

systemctl daemon-reload
systemctl restart docker

# Set alias for kubectl command
echo "alias k=kubectl" >> /home/vagrant/.bashrc

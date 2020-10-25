NODE=$1
NODE_HOST_IP=20+$NODE

$(cat /vagrant/kubeadm-init.out | grep -A 2 "kubeadm join" | sed -e 's/^[ \t]*//' | tr '\n' ' ' | sed -e 's/ \\ / /g')
echo KUBELET_EXTRA_ARGS=--node-ip=10.8.8.$NODE_HOST_IP > /etc/default/kubelet
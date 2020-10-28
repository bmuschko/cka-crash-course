# Solution

## Initializing the Control Plane on Master Node

After shelling into the master node, run the `kubeadm init` command as root user. The output contains follow up command you will keep track of.

```
$ sudo kubeadm init --pod-network-cidr 172.18.0.0/16 --apiserver-advertise-address 10.8.8.10
...
To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 10.8.8.10:6443 --token fi8io0.dtkzsy9kws56dmsp \
    --discovery-token-ca-cert-hash sha256:cc89ea1f82d5ec460e21b69476e0c052d691d0c52cce83fbd7e403559c1ebdac
```

Next, execute the commands from the output:

```
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

It's recommended to install a Pod network add-on. We'll use Calico here. The following commands download the manifest with version 3.10, change the IP address range, and then apply the manifest.

```
wget -q https://docs.projectcalico.org/v3.10/manifests/calico.yaml -O /tmp/calico-default.yaml
sed "s+192.168.0.0/16+$POD_CIDR+g" /tmp/calico-default.yaml > /tmp/calico-defined.yaml

kubectl apply -f /tmp/calico-defined.yaml
rm /tmp/calico-default.yaml /tmp/calico-defined.yaml
```

The list of nodes should show the following output:

```
$ kubectl get nodes
NAME            STATUS   ROLES    AGE     VERSION
kube-master     Ready    master   7m42s   v1.19.3
```

Exit the master node.

## Joining the Worker Nodes

Shell into worker node 1 or 2, and run the `kubeadm join` command. You can simply copy the command from the output of the `init` command. The following command showns an example. Remember that the token and SHA256 hash will be different for you.

```
$ sudo kubeadm join 10.8.8.10:6443 --token fi8io0.dtkzsy9kws56dmsp --discovery-token-ca-cert-hash sha256:cc89ea1f82d5ec460e21b69476e0c052d691d0c52cce83fbd7e403559c1ebdac
```

After applying the `join` command for both worker nodes, the list of nodes should render the following output. The command needs to be run on the master node.

```
$ kubectl get nodes
NAME            STATUS   ROLES    AGE   VERSION
kube-master     Ready    master   43m   v1.19.3
kube-worker-1   Ready    <none>   36m   v1.19.3
kube-worker-2   Ready    <none>   61s   v1.19.3
```
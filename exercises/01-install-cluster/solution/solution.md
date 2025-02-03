# Solution

You can find a full description of the [installation steps](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/) in the official Kubernetes documentation. The instructions below describe the manual steps. This directory also contains `Vagrantfile` that creates the full cluster in one swoop without manual intervention.

## Initializing the Control Plane Node

Open an interactive shell to the control plane node.

```
$ vagrant ssh kube-control-plane
```

Run the `kubeadm init` command as root user. This initializes the control plane node. The output contains follow up command you will keep track of.

```
$ sudo kubeadm init --pod-network-cidr 172.18.0.0/16
...
To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:

kubeadm join 192.168.2.167:6443 --token bwpn4g.g8duvvhgw0aqneh0 \
	--discovery-token-ca-cert-hash sha256:b8cf484cea5b05eb9415b3ec6d36f5586330d2f62f332ee9d3336a2a4dabd13b
```

Should you forget about the `join` command, run the following to retrieve it.

```
$ kubeadm token create --print-join-command
```

Next, execute the commands from the output:

```
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

It's recommended to install a Pod network add-on. We'll use Calico here. The following command applies the manifest with version 3.25.

```
$ kubectl apply -f https://projectcalico.docs.tigera.io/archive/v3.25/manifests/calico.yaml
poddisruptionbudget.policy/calico-kube-controllers created
serviceaccount/calico-kube-controllers created
serviceaccount/calico-node created
configmap/calico-config created
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/caliconodestatuses.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/ipreservations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org created
clusterrole.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrole.rbac.authorization.k8s.io/calico-node created
clusterrolebinding.rbac.authorization.k8s.io/calico-kube-controllers created
clusterrolebinding.rbac.authorization.k8s.io/calico-node created
daemonset.apps/calico-node created
deployment.apps/calico-kube-controllers created
```

The list of nodes should show the following output:

```
$ kubectl get nodes
NAME                 STATUS   ROLES           AGE     VERSION
kube-control-plane   Ready    control-plane   2m34s   v1.31.1
```

Exit the control plane node by running the `exit` command.

## Joining the Worker Nodes

Open an interactive shell to the worker node.

```
$ vagrant ssh ssh kube-worker-1
```

Shell into worker node 1 with the command `vagrant ssh kube-worker-1`, and run the `kubeadm join` command. You can simply copy the command from the output of the `init` command. The following command showns an example. Remember that the token and SHA256 hash will be different for you.

```
$ sudo kubeadm join 192.168.2.167:6443 --token bibmd6.h4zrig0d7zdr1k87 --discovery-token-ca-cert-hash sha256:b8cf484cea5b05eb9415b3ec6d36f5586330d2f62f332ee9d3336a2a4dabd13b
```

## Checking the Cluster

After applying the `join` command for both worker nodes, the list of nodes should render the following output from the control plane node. The command needs to be run on the control plane node.

```
$ kubectl get nodes
NAME                 STATUS   ROLES           AGE     VERSION
kube-control-plane   Ready    control-plane   4m27s   v1.31.1
kube-worker-1        Ready    <none>          48s     v1.31.1
```

## Verifying the Installation

To verify the installation, you can create a new Pod and inspect which node it is running on.

```
$ kubectl run nginx --image=nginx:1.25.4-alpine
pod/nginx created
$ kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          9s
$ kubectl describe pod nginx | grep Node:
Node:             kube-worker-1/192.168.2.168
```

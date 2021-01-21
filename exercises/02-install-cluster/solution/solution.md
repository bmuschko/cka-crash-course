# Solution

You can find a full description of the [installation steps](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/) in the official Kubernetes documentation. The instructions below describe the manual steps. This directory also contains `Vagrantfile` that creates the full cluster in one swoop without manual intervention.

## Initializing the Control Plane on Master Node

After shelling into the master node with `vagrant ssh kube-master`, run the `kubeadm init` command as root user. This initializes the control-plane node. The output contains follow up command you will keep track of.

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

It's recommended to install a Pod network add-on. We'll use Calico here. The following command applies the manifest with version 3.14.

```
$ kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml
configmap/calico-config configured
Warning: apiextensions.k8s.io/v1beta1 CustomResourceDefinition is deprecated in v1.16+, unavailable in v1.22+; use apiextensions.k8s.io/v1 CustomResourceDefinition
customresourcedefinition.apiextensions.k8s.io/bgpconfigurations.crd.projectcalico.org unchanged
customresourcedefinition.apiextensions.k8s.io/bgppeers.crd.projectcalico.org unchanged
customresourcedefinition.apiextensions.k8s.io/blockaffinities.crd.projectcalico.org unchanged
customresourcedefinition.apiextensions.k8s.io/clusterinformations.crd.projectcalico.org unchanged
customresourcedefinition.apiextensions.k8s.io/felixconfigurations.crd.projectcalico.org unchanged
customresourcedefinition.apiextensions.k8s.io/globalnetworkpolicies.crd.projectcalico.org configured
customresourcedefinition.apiextensions.k8s.io/globalnetworksets.crd.projectcalico.org unchanged
customresourcedefinition.apiextensions.k8s.io/hostendpoints.crd.projectcalico.org unchanged
customresourcedefinition.apiextensions.k8s.io/ipamblocks.crd.projectcalico.org unchanged
customresourcedefinition.apiextensions.k8s.io/ipamconfigs.crd.projectcalico.org unchanged
customresourcedefinition.apiextensions.k8s.io/ipamhandles.crd.projectcalico.org unchanged
customresourcedefinition.apiextensions.k8s.io/ippools.crd.projectcalico.org unchanged
customresourcedefinition.apiextensions.k8s.io/kubecontrollersconfigurations.crd.projectcalico.org created
customresourcedefinition.apiextensions.k8s.io/networkpolicies.crd.projectcalico.org unchanged
customresourcedefinition.apiextensions.k8s.io/networksets.crd.projectcalico.org unchanged
clusterrole.rbac.authorization.k8s.io/calico-kube-controllers configured
clusterrolebinding.rbac.authorization.k8s.io/calico-kube-controllers unchanged
clusterrole.rbac.authorization.k8s.io/calico-node configured
clusterrolebinding.rbac.authorization.k8s.io/calico-node unchanged
daemonset.apps/calico-node configured
serviceaccount/calico-node unchanged
deployment.apps/calico-kube-controllers configured
serviceaccount/calico-kube-controllers unchanged
```

The list of nodes should show the following output:

```
$ kubectl get nodes
NAME          STATUS   ROLES                  AGE   VERSION
kube-master   Ready    control-plane,master   11m   v1.20.2
```

Exit the master node by running the `exit` command.

## Joining the Worker Nodes

Shell into worker node 1 or 2 with the command `vagrant ssh kube-worker-1` or `vagrant ssh kube-worker-2`, and run the `kubeadm join` command. You can simply copy the command from the output of the `init` command. The following command showns an example. Remember that the token and SHA256 hash will be different for you.

```
$ sudo kubeadm join 10.8.8.10:6443 --token fi8io0.dtkzsy9kws56dmsp --discovery-token-ca-cert-hash sha256:cc89ea1f82d5ec460e21b69476e0c052d691d0c52cce83fbd7e403559c1ebdac
```

After applying the `join` command for both worker nodes, the list of nodes should render the following output. The command needs to be run on the master node.

```
$ kubectl get nodes
NAME            STATUS   ROLES                  AGE    VERSION
kube-master     Ready    control-plane,master   17m    v1.20.2
kube-worker-1   Ready    <none>                 109s   v1.20.2
kube-worker-2   Ready    <none>                 39s    v1.20.2
```

## Verifying the Installation

To verify the installation, you can create a new Pod and inspect which node it is running on.

```
$ kubectl run nginx --image=nginx
pod/nginx created
$ kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
nginx   1/1     Running   0          9s
$ kubectl describe pod nginx | grep Node:
Node:         kube-worker-1/10.0.2.15
```
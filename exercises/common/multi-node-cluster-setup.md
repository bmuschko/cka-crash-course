# Setting up a multi-node cluster

## Using Minikube

You can start the cluster with three nodes with the command `minikube start --nodes 3` for a brand new cluster or with the command `minikube node add` to add nodes to existing cluster. See the [official documentation](https://minikube.sigs.k8s.io/docs/tutorials/multi_node/) for more information.

Verify the existing nodes with the following command. Minikube creates the control plane node named `minikube`, and two worker nodes named `minikube-m02` and `minikube-m03`.

```
$ kubectl get nodes
NAME           STATUS   ROLES           AGE     VERSION
minikube       Ready    control-plane   4m6s    v1.24.3
minikube-m02   Ready    <none>          3m28s   v1.24.3
minikube-m03   Ready    <none>          2m51s   v1.24.3
```

## Using a Regular Kubernetes Cluster

Refer to the [Kubernetes documentation](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#join-nodes) to join a node to the cluster.

Verify the existing nodes with the following command. The cluster consists of a control plane node named `controlplane`, and one worker node named `node01`.

```
$ kubectl get nodes
NAME           STATUS   ROLES                  AGE     VERSION
controlplane   Ready    control-plane,master   5m15s   v1.23.4
node01         Ready    <none>                 4m39s   v1.23.4
```
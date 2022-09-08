# Exercise 2

In this exercise, you will learn how to create a cluster using kubeadm. The cluster will contain of a single control plane node named `kube-control-plane`, and two worker nodes named `kube-worker-1` and `kube-worker-2`. The existing setup uses virtual machines (VMs) to emulate the cluster environment.

> **_NOTE:_** The file [vagrant-setup.md](../common/vagrant-setup.md) describes the setup instructions and commands for Vagrant and VirtualBox. If you do not want to use the Vagrant environment, you can use the Katacoda lab ["Installing a Kubernetes cluster"](https://learning.oreilly.com/scenarios/cka-prep-installing/9781492095507/).

## Initializing the Control Plane Node

1. Shell into control plane node using the command `vagrant ssh kube-control-plane`.
2. Initializing the control plane using the `kubeadm init` command. Provide `172.18.0.0/16` as the IP addresses for the Pod network. Use `192.168.56.10` for the IP address the API Server will advertise it's listening on.
3. After the `init` command finished, run the necessary commands to run the cluster as non-root user.
4. Install Calico as with the version 3.22 using the command `kubectl apply -f https://projectcalico.docs.tigera.io/archive/v3.22/manifests/calico.yaml`. For more details on Calico, see the [installation quickstart guide](https://docs.projectcalico.org/getting-started/kubernetes/quickstart).
5. Verify that the control plabe node indicates the "Ready" status with the command `kubectl get nodes`.
6. Exit out of the VM using the command `exit`.

## Joining the Worker Nodes

1. Shell into first worker node using the command `vagrant ssh kube-worker-1`.
2. Join the worker node to cluster using the `kubeadm join` command. Provide the join token and CA cert hash.
3. Verify that the worker node indicates the "Ready" status with the command `kubectl get nodes`.
4. Exit out of the VM using the command `exit`.
5. Repeat the steps for worker node `kube-worker-2`.
6. Exit out of the VM using the command `exit`.

## Verifying the Installation

1. Shell into control plane node using the command `vagrant ssh kube-control-plane`.
2. Check that all nodes have been correctly registered and are in the "Ready" status.
3. Create a new Pod named `nginx` with the image `nginx`. Check the node the Pod has been scheduled on.

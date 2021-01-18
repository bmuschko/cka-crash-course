# Exercise 2

In this exercise, you will learn how to create a cluster using kubeadm. The cluster will contain of a single master node named `kube-master`, and two worker nodes named `kube-worker-1` and `kube-worker-2`. The existing setup uses virtual machines (VMs) to emulate the cluster environment.

Start the VMs using the command `vagrant up`. Depending on the hardware and network connectivity of your machine, this process may take a couple of minutes. After you are done with the exercise, shut down the VMs with the command `vagrant destroy -f`.

## Initializing the Control Plane on Master Node

1. Shell into master node using the command `vagrant ssh kube-master`.
2. Initializing the control plane using the `kubeadm init` command. Provide `172.18.0.0/16` as the IP addresses for the Pod network. Use `10.8.8.10` for the IP address the API Server will advertise it's listening on.
3. After the `init` command finished, run the necessary commands to run the cluster as non-root user.
4. Install Calico as with the verison 3.14 using the command `kubectl apply -f https://docs.projectcalico.org/v3.14/manifests/calico.yaml`. For more details on Calico, see the [installation quickstart guide](https://docs.projectcalico.org/getting-started/kubernetes/quickstart).
5. Verify that the master nodes indicates the "Ready" status with the command `kubectl get nodes`.
6. Exit out of the VM using the command `exit`.

## Joining the Worker Nodes

1. Shell into first worker node using the command `vagrant ssh kube-worker-1`.
2. Join the worker node to cluster using the `kubeadm join` command. Provide the join token and CA cert hash.
3. Verify that the worker node indicates the "Ready" status with the command `kubectl get nodes`.
4. Exit out of the VM using the command `exit`.
5. Repeat the steps for worker node `kube-worker-2`.
6. Exit out of the VM using the command `exit`.

## Verifying the Installation

1. Shell into master node using the command `vagrant ssh kube-master`.
2. Check that all nodes have been correctly registered and are in the "Ready" status.
3. Create a new Pod named `nginx` with the image `nginx`. Check the node the Pod has been scheduled on.
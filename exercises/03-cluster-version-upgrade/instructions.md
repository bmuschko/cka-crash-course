# Exercise 3

In this exercise, you will learn how to upgrade the cluster version from 1.18.0 to 1.19.0 using kubeadm. The cluster will contain of a single master node named `kube-master`, and one worker node named `kube-worker-1`. The existing setup uses virtual machines (VMs) to emulate the cluster environment.

Start the VMs using the command `vagrant up`. Depending on the hardware and network connectivity of your machine, this process may take a couple of minutes. After you are done with the exercise, shut down the VMs with the command `vagrant destroy -f`.

## Upgrading the Master Node

1. Shell into the master node with `vagrant ssh kube-master`.
2. Upgrade kubeadm to `1.19.0-00` via `apt-get`. Verify that the correct version has been set.
3. Drain the control plane node.
4. Use the appropriate kubeadm command to upgrade the control plane to `1.19.0`.
5. Uncordon the control plane node.
6. Upgrade kubelet and kubectl to `1.19.0-00`.
7. Restart the kubelet.
8. Exit out of the node.

## Upgrading the Worker Node

1. Shell into the worker node with `vagrant ssh kube-worker-1`.
2. Upgrade kubeadm to `1.19.0-00` via `apt-get`. Verify that the correct version has been set.
3. Drain the node.
4. Upgrade the kubelet configuration.
5. Upgrade kubelet and kubectl to `1.19.0-00`.
6. Restart the kubelet.
7. Uncordon the node.
8. Exit out of the node.
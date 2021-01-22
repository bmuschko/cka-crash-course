# Exercise 16

In this exercise, you will learn how to troubleshooting the underlying issue of worker node. The cluster will contain of a single master node named `kube-master`, and one worker node named `kube-worker-1`. The existing setup uses virtual machines (VMs) to emulate the cluster environment.

Start the VMs using the command `vagrant up`. Depending on the hardware and network connectivity of your machine, this process may take a couple of minutes. After you are done with the exercise, shut down the VMs with the command `vagrant destroy -f`.

1. Check the status of the nodes. Do you see an issue?
2. Shell into the node having an issue and identify the root cause.
3. Fix the root cause and restart the node.
4. The status of the previously failing node should say "Ready".
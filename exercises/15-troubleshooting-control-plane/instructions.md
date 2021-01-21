# Exercise 15

In this exercise, you will learn how to troubleshooting the underlying issue of a Deployment not being able to schedule its Pods. The cluster will contain of a single master node named `kube-master`, and one worker node named `kube-worker-1`. The existing setup uses virtual machines (VMs) to emulate the cluster environment.

Start the VMs using the command `vagrant up`. Depending on the hardware and network connectivity of your machine, this process may take a couple of minutes. After you are done with the exercise, shut down the VMs with the command `vagrant destroy -f`.

1. Check the status of the Deployment named `deploy` and its Pods. How many Pods have been scheduled?
2. Check the events of any of the Pods.
3. Check the status of the Pods in the namespace `kube-system`. Can you identify an issue?
4. Fix the issue so that the Deployment can schedule all three replicas.
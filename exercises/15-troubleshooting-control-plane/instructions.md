# Exercise 15

In this exercise, you will learn how to troubleshooting the underlying issue of a Deployment not being able to schedule its Pods. The cluster will contain of a single control plane node named `kube-control-plane`, and one worker node named `kube-worker-1`. The existing setup uses virtual machines (VMs) to emulate the cluster environment.

> **_NOTE:_** The file [vagrant-setup.md](../common/vagrant-setup.md) describes the setup instructions and commands for Vagrant and VirtualBox. If you do not want to use the Vagrant environment, you can use the Katacoda lab ["Troubleshooting a control plane node"](https://learning.oreilly.com/scenarios/cka-prep-troubleshooting/9781492099215/).

1. Check the status of the Deployment named `deploy` and its Pods. How many Pods have been scheduled?
2. Check the events of any of the Pods.
3. Check the status of the Pods in the namespace `kube-system`. Can you identify an issue?
4. Fix the issue so that the Deployment can schedule all three replicas.
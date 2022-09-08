# Exercise 16

In this exercise, you will learn how to troubleshooting the underlying issue of worker node. The cluster will contain of a single control plane node named `kube-control-plane`, and one worker node named `kube-worker-1`. The existing setup uses virtual machines (VMs) to emulate the cluster environment.

> **_NOTE:_** The file [vagrant-setup.md](../common/vagrant-setup.md) describes the setup instructions and commands for Vagrant and VirtualBox. If you do not want to use the Vagrant environment, you can use the Katacoda lab ["Troubleshooting a worker node"](https://learning.oreilly.com/scenarios/cka-prep-troubleshooting/9781492099222/).

1. Check the status of the nodes. Do you see an issue?
2. Shell into the node having an issue and identify the root cause.
3. Fix the root cause and restart the node.
4. The status of the previously failing node should say "Ready".
# Interacting with a Vagrant Kubernetes Cluster

You will need to install the tools Vagrant and VirtualBox to set up a Virtual Machine (VM) cluster with Kubernetes set up on it. For more information, see the [prerequisites](../../prerequisites/instructions.md).

## Starting up the Cluster

Start the VMs using the command `vagrant up`. Depending on the hardware and network connectivity of your machine, this process may take a couple of minutes.

```
$ vagrant up
```

## Shelling into a VM

The Kubernetes cluster consists of a control plane node running on `kube-control-plane` and a worker node `kube-worker-1`. You can SSH into a VM using the command `vagrant ssh <vm-name>`. The following command shows how to shell into the VM `kube-control-plane`. To leave the VM, run the `exit` command.

```
$ vagrant ssh kube-control-plane
...
vagrant@kube-control-plane:~$
```

## Destroying the Cluster

After you are done with the exercise, shut down the VMs with the command `vagrant destroy -f`. Leaving the VM running would result in unnecessary consumption of resources on your machine.

```
$ vagrant destroy -f
==> kube-worker-1: Forcing shutdown of VM...
==> kube-worker-1: Destroying VM and associated drives...
==> kube-control-plane: Forcing shutdown of VM...
==> kube-control-plane: Destroying VM and associated drives...
```
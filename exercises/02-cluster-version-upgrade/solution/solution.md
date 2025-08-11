# Solution

You can find a detailed description of the upgrade steps in the [official Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/).

## Upgrading the Control Plane Node

Open an interactive shell to the control plane node.

```
$ vagrant ssh kube-control-plane
```

First, check the nodes and their Kubernetes versions. You will see that all nodes run on version 1.31.1.

```
$ kubectl get nodes
NAME                 STATUS   ROLES           AGE    VERSION
kube-control-plane   Ready    control-plane   4m3s   v1.31.1
kube-worker-1        Ready    <none>          72s    v1.31.1
```

Install the kubeadm version 1.31.5-1.1 and check its version.

```
$ sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm=1.31.5-1.1 && sudo apt-mark hold kubeadm
Canceled hold on kubeadm.
Hit:1 https://download.docker.com/linux/ubuntu oracular InRelease
Hit:3 http://ports.ubuntu.com/ubuntu-ports oracular InRelease
Hit:4 http://deb.gierens.de stable InRelease
Hit:5 http://ports.ubuntu.com/ubuntu-ports oracular-updates InRelease
Hit:6 http://ports.ubuntu.com/ubuntu-ports oracular-backports InRelease
Hit:7 http://ports.ubuntu.com/ubuntu-ports oracular-security InRelease
Hit:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 94 not upgraded.
Need to get 9,810 kB of archives.
After this operation, 0 B of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  kubeadm 1.31.5-1.1 [9,810 kB]
Fetched 9,810 kB in 21s (473 kB/s)
(Reading database ... 56358 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.31.5-1.1_arm64.deb ...
Unpacking kubeadm (1.31.5-1.1) over (1.31.1-1.1) ...
Setting up kubeadm (1.31.5-1.1) ...
Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
kubeadm set on hold.

$ sudo apt-get update && sudo apt-get install -y --allow-change-held-packages kubeadm=1.31.5-1.1
Hit:1 https://download.docker.com/linux/ubuntu oracular InRelease
Hit:3 http://ports.ubuntu.com/ubuntu-ports oracular InRelease
Hit:4 http://deb.gierens.de stable InRelease
Hit:5 http://ports.ubuntu.com/ubuntu-ports oracular-updates InRelease
Hit:6 http://ports.ubuntu.com/ubuntu-ports oracular-backports InRelease
Hit:7 http://ports.ubuntu.com/ubuntu-ports oracular-security InRelease
Hit:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
kubeadm is already the newest version (1.31.5-1.1).
0 upgraded, 0 newly installed, 0 to remove and 94 not upgraded.

$ kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"31", GitVersion:"v1.31.5", GitCommit:"af64d838aacd9173317b39cf273741816bd82377", GitTreeState:"clean", BuildDate:"2025-01-15T14:39:21Z", GoVersion:"go1.22.10", Compiler:"gc", Platform:"linux/arm64"}
```

Check the available versions.

```
$ sudo kubeadm upgrade plan
[preflight] Running pre-flight checks.
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: 1.31.5
[upgrade/versions] kubeadm version: v1.31.5
I0130 18:22:47.687526    9393 version.go:261] remote version is much newer: v1.32.1; falling back to: stable-1.31
[upgrade/versions] Target version: v1.31.5
[upgrade/versions] Latest version in the v1.31 series: v1.31.5
```

Apply the upgrade.

```
$ sudo kubeadm upgrade apply v1.31.5
[preflight] Running pre-flight checks.
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[upgrade] Running cluster health checks
[upgrade/version] You have chosen to change the cluster version to "v1.31.5"
[upgrade/versions] Cluster version: v1.31.5
[upgrade/versions] kubeadm version: v1.31.5
[upgrade] Are you sure you want to proceed? [y/N]: y
[upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
[upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
[upgrade/prepull] You can also perform this action beforehand using 'kubeadm config images pull'
W0130 18:23:28.987632    9467 checks.go:846] detected that the sandbox image "registry.k8s.io/pause:3.8" of the container runtime is inconsistent with that used by kubeadm.It is recommended to use "registry.k8s.io/pause:3.10" as the CRI sandbox image.
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.31.5" (timeout: 5m0s)...
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests2848669133"
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Current and new manifests of etcd are equal, skipping upgrade
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Current and new manifests of kube-apiserver are equal, skipping upgrade
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Current and new manifests of kube-controller-manager are equal, skipping upgrade
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Current and new manifests of kube-scheduler are equal, skipping upgrade
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upgrade] Backing up kubelet config file to /etc/kubernetes/tmp/kubeadm-kubelet-config3138185094/config.yaml
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.31.5". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.
```

Drain the control plane node by evicting workload.

```
$ kubectl drain kube-control-plane --ignore-daemonsets
node/kube-control-plane cordoned
Warning: ignoring DaemonSet-managed Pods: calico-system/calico-node-sw9gw, calico-system/csi-node-driver-wgwpw, kube-system/kube-proxy-pnn45
evicting pod tigera-operator/tigera-operator-748c69cf45-wl7ms
evicting pod calico-apiserver/calico-apiserver-7c896d4878-dhwjn
evicting pod calico-apiserver/calico-apiserver-7c896d4878-gcnkt
evicting pod calico-system/calico-kube-controllers-5cb46799b5-88kz7
evicting pod calico-system/calico-typha-6455f874-x8sms
evicting pod kube-system/coredns-76f75df574-s6sv5
evicting pod kube-system/coredns-76f75df574-wfkvr
pod/tigera-operator-748c69cf45-wl7ms evicted
pod/calico-apiserver-7c896d4878-gcnkt evicted
pod/calico-apiserver-7c896d4878-dhwjn evicted
pod/calico-kube-controllers-5cb46799b5-88kz7 evicted
pod/coredns-76f75df574-wfkvr evicted
pod/coredns-76f75df574-s6sv5 evicted
pod/calico-typha-6455f874-x8sms evicted
node/kube-control-plane drained
```

Upgrade kubelet and kubectl.

```
$ sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet=1.31.5-1.1 kubectl=1.31.5-1.1 && sudo apt-mark hold kubelet kubectl
Canceled hold on kubelet.
Canceled hold on kubectl.
Hit:2 https://download.docker.com/linux/ubuntu oracular InRelease
Hit:3 http://ports.ubuntu.com/ubuntu-ports oracular InRelease
Hit:4 http://deb.gierens.de stable InRelease
Hit:5 http://ports.ubuntu.com/ubuntu-ports oracular-updates InRelease
Hit:6 http://ports.ubuntu.com/ubuntu-ports oracular-backports InRelease
Hit:7 http://ports.ubuntu.com/ubuntu-ports oracular-security InRelease
Hit:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 92 not upgraded.
Need to get 22.6 MB of archives.
After this operation, 41.0 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  kubectl 1.31.5-1.1 [9,636 kB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  kubelet 1.31.5-1.1 [13.0 MB]
Fetched 22.6 MB in 21s (1,067 kB/s)
(Reading database ... 56358 files and directories currently installed.)
Preparing to unpack .../kubectl_1.31.5-1.1_arm64.deb ...
Unpacking kubectl (1.31.5-1.1) over (1.31.1-1.1) ...
Preparing to unpack .../kubelet_1.31.5-1.1_arm64.deb ...
Unpacking kubelet (1.31.5-1.1) over (1.31.1-1.1) ...
Setting up kubectl (1.31.5-1.1) ...
Setting up kubelet (1.31.5-1.1) ...
Scanning processes...
Scanning candidates...
Scanning linux images...

Running kernel seems to be up-to-date.

Restarting services...
 systemctl restart kubelet.service

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
kubelet set on hold.
kubectl set on hold.
```

Restart the kubelet.

```
$ sudo systemctl daemon-reload
$ sudo systemctl restart kubelet
```

Bring the node back online by marking it schedulable.

```
$ kubectl uncordon kube-control-plane
node/kube-control-plane uncordoned
```

The control plane node should now show the usage of Kubernetes 1.31.5.

```
$ kubectl get nodes
NAME                 STATUS   ROLES           AGE     VERSION
kube-control-plane   Ready    control-plane   8m58s   v1.31.5
kube-worker-1        Ready    <none>          6m8s    v1.31.1
```

Exit the control plane node.

```
$ exit
```

## Upgrading the Worker Node

Open an interactive shell to the worker node.

```
$ vagrant ssh kube-worker-1
```

Upgrade kubeadm to version 1.31.5-1.1.

```
$ sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm=1.31.5-1.1 && sudo apt-mark hold kubeadm
Canceled hold on kubeadm.
Hit:2 https://download.docker.com/linux/ubuntu oracular InRelease
Hit:3 http://deb.gierens.de stable InRelease
Hit:4 http://ports.ubuntu.com/ubuntu-ports oracular InRelease
Get:5 http://ports.ubuntu.com/ubuntu-ports oracular-updates InRelease [126 kB]
Get:6 http://ports.ubuntu.com/ubuntu-ports oracular-backports InRelease [126 kB]
Get:7 http://ports.ubuntu.com/ubuntu-ports oracular-security InRelease [126 kB]
Get:8 http://ports.ubuntu.com/ubuntu-ports oracular-updates/main arm64 Packages [259 kB]
Get:9 http://ports.ubuntu.com/ubuntu-ports oracular-updates/main arm64 Components [32.3 kB]
Get:10 http://ports.ubuntu.com/ubuntu-ports oracular-updates/restricted arm64 Components [216 B]
Get:11 http://ports.ubuntu.com/ubuntu-ports oracular-updates/universe arm64 Packages [154 kB]
Get:12 http://ports.ubuntu.com/ubuntu-ports oracular-updates/universe arm64 Components [53.2 kB]
Get:13 http://ports.ubuntu.com/ubuntu-ports oracular-updates/multiverse arm64 Components [212 B]
Get:14 http://ports.ubuntu.com/ubuntu-ports oracular-backports/main arm64 Components [212 B]
Get:15 http://ports.ubuntu.com/ubuntu-ports oracular-backports/restricted arm64 Components [216 B]
Get:16 http://ports.ubuntu.com/ubuntu-ports oracular-backports/universe arm64 Components [9,700 B]
Get:17 http://ports.ubuntu.com/ubuntu-ports oracular-backports/multiverse arm64 Components [216 B]
Get:18 http://ports.ubuntu.com/ubuntu-ports oracular-security/main arm64 Components [5,672 B]
Get:19 http://ports.ubuntu.com/ubuntu-ports oracular-security/restricted arm64 Components [212 B]
Get:20 http://ports.ubuntu.com/ubuntu-ports oracular-security/universe arm64 Components [5,184 B]
Get:21 http://ports.ubuntu.com/ubuntu-ports oracular-security/multiverse arm64 Components [212 B]
Hit:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  InRelease
Fetched 899 kB in 20s (44.1 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 94 not upgraded.
Need to get 9,810 kB of archives.
After this operation, 0 B of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  kubeadm 1.31.5-1.1 [9,810 kB]
Fetched 9,810 kB in 21s (471 kB/s)
(Reading database ... 56358 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.31.5-1.1_arm64.deb ...
Unpacking kubeadm (1.31.5-1.1) over (1.31.1-1.1) ...
Setting up kubeadm (1.31.5-1.1) ...
Scanning processes...
Scanning linux images...

Running kernel seems to be up-to-date.

No services need to be restarted.

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
kubeadm set on hold.
```

Upgrade the kubelet configuration.

```
$ sudo kubeadm upgrade node
[upgrade] Reading configuration from the cluster...
[upgrade] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks
[preflight] Skipping prepull. Not a control plane node.
[upgrade] Skipping phase. Not a control plane node.
[upgrade] Skipping phase. Not a control plane node.
[upgrade] Backing up kubelet config file to /etc/kubernetes/tmp/kubeadm-kubelet-config2589728848/config.yaml
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[upgrade] The configuration for this node was successfully updated!
[upgrade] Now you should go ahead and upgrade the kubelet package using your package manager.
```

Drain the node.

```
$ kubectl drain kube-worker-1 --ignore-daemonsets
node/kube-worker-1 cordoned
Warning: ignoring DaemonSet-managed Pods: calico-system/calico-node-c9mh5, calico-system/csi-node-driver-wlvlp, kube-system/kube-proxy-ghf74
evicting pod calico-apiserver/calico-apiserver-7c896d4878-867ts
evicting pod tigera-operator/tigera-operator-748c69cf45-hfw98
evicting pod calico-apiserver/calico-apiserver-7c896d4878-j8pq2
evicting pod calico-system/calico-kube-controllers-5cb46799b5-dt57r
evicting pod calico-system/calico-typha-6455f874-p574s
evicting pod kube-system/coredns-76f75df574-nzb9x
evicting pod kube-system/coredns-76f75df574-tf69t
pod/tigera-operator-748c69cf45-hfw98 evicted
I0717 21:07:41.175388   10682 request.go:697] Waited for 1.083636399s due to client-side throttling, not priority and fairness, request: GET:https://192.168.56.10:6443/api/v1/namespaces/calico-system/pods/calico-kube-controllers-5cb46799b5-dt57r
pod/calico-kube-controllers-5cb46799b5-dt57r evicted
pod/calico-apiserver-7c896d4878-867ts evicted
pod/calico-apiserver-7c896d4878-j8pq2 evicted
pod/coredns-76f75df574-tf69t evicted
pod/coredns-76f75df574-nzb9x evicted
pod/calico-typha-6455f874-p574s evicted
node/kube-worker-1 drained
```

Upgrade kubelet and kubectl.

```
$ sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet=1.31.5-1.1 kubectl=1.31.5-1.1 && sudo apt-mark hold kubelet kubectl
Canceled hold on kubelet.
Canceled hold on kubectl.
Hit:1 https://download.docker.com/linux/ubuntu oracular InRelease
Hit:3 http://ports.ubuntu.com/ubuntu-ports oracular InRelease
Hit:4 http://deb.gierens.de stable InRelease
Hit:5 http://ports.ubuntu.com/ubuntu-ports oracular-updates InRelease
Hit:6 http://ports.ubuntu.com/ubuntu-ports oracular-backports InRelease
Hit:7 http://ports.ubuntu.com/ubuntu-ports oracular-security InRelease
Hit:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 92 not upgraded.
Need to get 22.6 MB of archives.
After this operation, 41.0 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  kubectl 1.31.5-1.1 [9,636 kB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.31/deb  kubelet 1.31.5-1.1 [13.0 MB]
Fetched 22.6 MB in 21s (1,083 kB/s)
(Reading database ... 56358 files and directories currently installed.)
Preparing to unpack .../kubectl_1.31.5-1.1_arm64.deb ...
Unpacking kubectl (1.31.5-1.1) over (1.31.1-1.1) ...
Preparing to unpack .../kubelet_1.31.5-1.1_arm64.deb ...
Unpacking kubelet (1.31.5-1.1) over (1.31.1-1.1) ...
Setting up kubectl (1.31.5-1.1) ...
Setting up kubelet (1.31.5-1.1) ...
Scanning processes...
Scanning candidates...
Scanning linux images...

Running kernel seems to be up-to-date.

Restarting services...
 systemctl restart kubelet.service

No containers need to be restarted.

No user sessions are running outdated binaries.

No VM guests are running outdated hypervisor (qemu) binaries on this host.
kubelet set on hold.
kubectl set on hold.
```

Restart the kubelet.

```
$ sudo systemctl daemon-reload
$ sudo systemctl restart kubelet
```

Bring the node back online by marking it schedulable.

```
$ kubectl uncordon kube-worker-1
node/kube-worker-1 uncordoned
```

Listing the nodes should now show version 1.31.5 for the worker node.

```
$ kubectl get nodes
NAME                 STATUS   ROLES           AGE     VERSION
kube-control-plane   Ready    control-plane   12m     v1.31.5
kube-worker-1        Ready    <none>          9m45s   v1.31.5
```

Exit the worker node.

```
$ exit
```

# Solution

You can find a detailed description of the upgrade steps in the [offical Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/).

## Upgrading the Control Plane Node

Shell into the control plane node.

```
$ vagrant ssh kube-control-plane
```

First, check the nodes and their Kubernetes versions. You will see that all nodes run on version 1.26.1.

```
$ kubectl get nodes
NAME                 STATUS   ROLES           AGE     VERSION
kube-control-plane   Ready    control-plane   3m33s   v1.26.1
kube-worker-1        Ready    <none>          69s     v1.26.1
```

Install the kubeadm version 1.26.14-1.1 and check its version.

```
$ sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm=1.26.14-1.1 && sudo apt-mark hold kubeadm
kubeadm was already not hold.
Hit:1 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:3 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.26/deb  InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 11 not upgraded.
Need to get 9827 kB of archives.
After this operation, 172 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.26/deb  kubeadm 1.26.14-1.1 [9827 kB]
Fetched 9827 kB in 2s (5931 kB/s)
(Reading database ... 60456 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.26.14-1.1_amd64.deb ...
Unpacking kubeadm (1.26.14-1.1) over (1.26.1-1.1) ...
Setting up kubeadm (1.26.14-1.1) ...
kubeadm set on hold.

$ sudo apt-get update && sudo apt-get install -y --allow-change-held-packages kubeadm=1.26.14-1.1
Hit:2 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:3 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.26/deb  InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
kubeadm is already the newest version (1.26.14-1.1).
0 upgraded, 0 newly installed, 0 to remove and 11 not upgraded.

$ kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"26", GitVersion:"v1.26.14", GitCommit:"6db79806d788bfb9cfc996deb7e2e178402e8b50", GitTreeState:"clean", BuildDate:"2024-02-14T10:40:25Z", GoVersion:"go1.21.7", Compiler:"gc", Platform:"linux/amd64"}
```

Check the available versions.

```
$ sudo kubeadm upgrade plan
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: v1.26.14
[upgrade/versions] kubeadm version: v1.26.14
I0314 14:41:48.705612   17485 version.go:256] remote version is much newer: v1.29.2; falling back to: stable-1.26
[upgrade/versions] Target version: v1.26.14
[upgrade/versions] Latest version in the v1.26 series: v1.26.14
```

Apply the upgrade.

```
$ sudo kubeadm upgrade apply v1.26.14
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade/version] You have chosen to change the cluster version to "v1.26.14"
[upgrade/versions] Cluster version: v1.26.14
[upgrade/versions] kubeadm version: v1.26.14
[upgrade] Are you sure you want to proceed? [y/N]: y
[upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
[upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
[upgrade/prepull] You can also perform this action in beforehand using 'kubeadm config images pull'
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.26.14" (timeout: 5m0s)...
[upgrade/etcd] Upgrading to TLS for etcd
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Renewing etcd-server certificate
[upgrade/staticpods] Renewing etcd-peer certificate
[upgrade/staticpods] Renewing etcd-healthcheck-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/etcd.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2024-03-14-14-42-46/etcd.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
[apiclient] Found 1 Pods for label selector component=etcd
[upgrade/staticpods] Component "etcd" upgraded successfully!
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests1252770869"
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Renewing apiserver certificate
[upgrade/staticpods] Renewing apiserver-kubelet-client certificate
[upgrade/staticpods] Renewing front-proxy-client certificate
[upgrade/staticpods] Renewing apiserver-etcd-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-apiserver.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2024-03-14-14-42-46/kube-apiserver.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
[apiclient] Found 1 Pods for label selector component=kube-apiserver
[upgrade/staticpods] Component "kube-apiserver" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Renewing controller-manager.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-controller-manager.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2024-03-14-14-42-46/kube-controller-manager.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
[apiclient] Found 1 Pods for label selector component=kube-controller-manager
[upgrade/staticpods] Component "kube-controller-manager" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Renewing scheduler.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-scheduler.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2024-03-14-14-42-46/kube-scheduler.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
[apiclient] Found 1 Pods for label selector component=kube-scheduler
[upgrade/staticpods] Component "kube-scheduler" upgraded successfully!
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.26.14". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.
```

Drain the control plane node by evicting workload.

```
$ kubectl drain kube-control-plane --ignore-daemonsets
node/kube-control-plane cordoned
Warning: ignoring DaemonSet-managed Pods: calico-system/calico-node-wl8jl, calico-system/csi-node-driver-wr5bd, kube-system/kube-proxy-z4758
evicting pod tigera-operator/tigera-operator-54b47459dd-w56ht
evicting pod calico-system/calico-kube-controllers-6b7b9c649d-xmt46
evicting pod calico-apiserver/calico-apiserver-569c5dd4b4-7qwqn
evicting pod calico-apiserver/calico-apiserver-569c5dd4b4-fk78n
evicting pod kube-system/coredns-787d4945fb-8gkq8
evicting pod calico-system/calico-typha-7d64594b69-vhb7b
evicting pod kube-system/coredns-787d4945fb-mxxkl
pod/tigera-operator-54b47459dd-w56ht evicted
pod/calico-apiserver-569c5dd4b4-7qwqn evicted
pod/calico-apiserver-569c5dd4b4-fk78n evicted
pod/calico-kube-controllers-6b7b9c649d-xmt46 evicted
pod/calico-typha-7d64594b69-vhb7b evicted
pod/coredns-787d4945fb-8gkq8 evicted
pod/coredns-787d4945fb-mxxkl evicted
node/kube-control-plane drained
```

Upgrade kubelet and kubectl.

```
$ sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet=1.26.14-1.1 kubectl=1.26.14-1.1 && sudo apt-mark hold kubelet kubectl
Canceled hold on kubelet.
Canceled hold on kubectl.
Hit:1 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:2 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:3 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Hit:6 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.26/deb  InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 9 not upgraded.
Need to get 31.2 MB of archives.
After this operation, 3644 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.26/deb  kubectl 1.26.14-1.1 [10.1 MB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.26/deb  kubelet 1.26.14-1.1 [21.1 MB]
Fetched 31.2 MB in 4s (7113 kB/s)
(Reading database ... 60456 files and directories currently installed.)
Preparing to unpack .../kubectl_1.26.14-1.1_amd64.deb ...
Unpacking kubectl (1.26.14-1.1) over (1.26.1-1.1) ...
Preparing to unpack .../kubelet_1.26.14-1.1_amd64.deb ...
Unpacking kubelet (1.26.14-1.1) over (1.26.1-1.1) ...
Setting up kubelet (1.26.14-1.1) ...
Setting up kubectl (1.26.14-1.1) ...
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

The control plane node should now show the usage of Kubernetes 1.26.14.

```
$ kubectl get nodes
NAME                 STATUS   ROLES           AGE   VERSION
kube-control-plane   Ready    control-plane   18m   v1.26.14
kube-worker-1        Ready    <none>          15m   v1.26.1
```

Exit the control plane node.

```
$ exit
```

## Upgrading the Worker Node

Shell into the worker node.

```
$ vagrant ssh kube-worker-1
```

Upgrade kubeadm to version 1.26.14-1.1.

```
$ sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm=1.26.14-1.1 && sudo apt-mark hold kubeadm
Canceled hold on kubeadm.
Hit:1 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:2 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:3 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:4 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Hit:6 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.26/deb  InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 11 not upgraded.
Need to get 9827 kB of archives.
After this operation, 172 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.26/deb  kubeadm 1.26.14-1.1 [9827 kB]
Fetched 9827 kB in 3s (3390 kB/s)
(Reading database ... 60456 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.26.14-1.1_amd64.deb ...
Unpacking kubeadm (1.26.14-1.1) over (1.26.1-1.1) ...
Setting up kubeadm (1.26.14-1.1) ...
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
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[upgrade] The configuration for this node was successfully updated!
[upgrade] Now you should go ahead and upgrade the kubelet package using your package manager.
```

Drain the node.

```
$ kubectl drain kube-worker-1 --ignore-daemonsets
node/kube-worker-1 cordoned
Warning: ignoring DaemonSet-managed Pods: calico-system/calico-node-tz7hx, calico-system/csi-node-driver-qwprr, kube-system/kube-proxy-rr76c
evicting pod tigera-operator/tigera-operator-54b47459dd-sqwjh
evicting pod calico-system/calico-kube-controllers-6b7b9c649d-j9gsc
evicting pod calico-apiserver/calico-apiserver-569c5dd4b4-gd67r
evicting pod calico-apiserver/calico-apiserver-569c5dd4b4-p5x8z
evicting pod kube-system/coredns-787d4945fb-n9bwd
evicting pod calico-system/calico-typha-7d64594b69-rwqzz
evicting pod kube-system/coredns-787d4945fb-s79d8
pod/tigera-operator-54b47459dd-sqwjh evicted
pod/calico-apiserver-569c5dd4b4-p5x8z evicted
pod/calico-kube-controllers-6b7b9c649d-j9gsc evicted
pod/calico-apiserver-569c5dd4b4-gd67r evicted
pod/calico-typha-7d64594b69-rwqzz evicted
pod/coredns-787d4945fb-s79d8 evicted
pod/coredns-787d4945fb-n9bwd evicted
node/kube-worker-1 drained
```

Upgrade kubelet and kubectl.

```
$ sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet=1.26.14-1.1 kubectl=1.26.14-1.1 && sudo apt-mark hold kubelet kubectl
Canceled hold on kubelet.
Canceled hold on kubectl.
Hit:1 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:2 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:3 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Hit:4 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:6 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:5 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.26/deb  InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 9 not upgraded.
Need to get 31.2 MB of archives.
After this operation, 3644 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.26/deb  kubectl 1.26.14-1.1 [10.1 MB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.26/deb  kubelet 1.26.14-1.1 [21.1 MB]
Fetched 31.2 MB in 4s (6998 kB/s)
(Reading database ... 60456 files and directories currently installed.)
Preparing to unpack .../kubectl_1.26.14-1.1_amd64.deb ...
Unpacking kubectl (1.26.14-1.1) over (1.26.1-1.1) ...
Preparing to unpack .../kubelet_1.26.14-1.1_amd64.deb ...
Unpacking kubelet (1.26.14-1.1) over (1.26.1-1.1) ...
Setting up kubelet (1.26.14-1.1) ...
Setting up kubectl (1.26.14-1.1) ...
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

Listing the nodes should now show version 1.26.14 for the worker node.

```
$ kubectl get nodes
NAME                 STATUS   ROLES           AGE   VERSION
kube-control-plane   Ready    control-plane   21m   v1.26.14
kube-worker-1        Ready    <none>          19m   v1.26.14
```

Exit the worker node.

```
$ exit
```

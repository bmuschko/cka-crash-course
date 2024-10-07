# Solution

You can find a detailed description of the upgrade steps in the [offical Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/).

## Upgrading the Control Plane Node

Shell into the control plane node.

```
$ vagrant ssh kube-control-plane
```

First, check the nodes and their Kubernetes versions. You will see that all nodes run on version 1.29.0.

```
$ kubectl get nodes
NAME                 STATUS   ROLES           AGE     VERSION
kube-control-plane   Ready    control-plane   3m59s   v1.29.0
kube-worker-1        Ready    <none>          2m16s   v1.29.0
```

Install the kubeadm version 1.29.6-1.1 and check its version.

```
$ sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm=1.29.6-1.1 && sudo apt-mark hold kubeadm
Canceled hold on kubeadm.
Hit:1 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:2 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:3 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:4 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Hit:5 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.29/deb  InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 15 not upgraded.
Need to get 10.1 MB of archives.
After this operation, 123 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.29/deb  kubeadm 1.29.6-1.1 [10.1 MB]
Fetched 10.1 MB in 1s (19.5 MB/s)
(Reading database ... 60457 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.29.6-1.1_amd64.deb ...
Unpacking kubeadm (1.29.6-1.1) over (1.29.0-1.1) ...
Setting up kubeadm (1.29.6-1.1) ...
kubeadm set on hold.

$ sudo apt-get update && sudo apt-get install -y --allow-change-held-packages kubeadm=1.29.6-1.1
Hit:2 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:3 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.29/deb  InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
kubeadm is already the newest version (1.29.6-1.1).
0 upgraded, 0 newly installed, 0 to remove and 15 not upgraded.

$ kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"29", GitVersion:"v1.29.6", GitCommit:"062798d53d83265b9e05f14d85198f74362adaca", GitTreeState:"clean", BuildDate:"2024-06-11T20:22:13Z", GoVersion:"go1.21.11", Compiler:"gc", Platform:"linux/amd64"}
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
[upgrade/versions] Cluster version: v1.29.7
[upgrade/versions] kubeadm version: v1.29.6
I0717 20:59:52.359800   11176 version.go:256] remote version is much newer: v1.30.3; falling back to: stable-1.29
[upgrade/versions] Target version: v1.29.7
[upgrade/versions] Latest version in the v1.29 series: v1.29.7
```

Apply the upgrade.

```
$ sudo kubeadm upgrade apply v1.29.6
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade/version] You have chosen to change the cluster version to "v1.29.6"
[upgrade/versions] Cluster version: v1.29.7
[upgrade/versions] kubeadm version: v1.29.6
[upgrade] Are you sure you want to proceed? [y/N]: y
[upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
[upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
[upgrade/prepull] You can also perform this action in beforehand using 'kubeadm config images pull'
W0717 21:00:39.094067   11300 checks.go:835] detected that the sandbox image "registry.k8s.io/pause:3.6" of the container runtime is inconsistent with that used by kubeadm. It is recommended that using "registry.k8s.io/pause:3.9" as the CRI sandbox image.
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.29.6" (timeout: 5m0s)...
[upgrade/etcd] Upgrading to TLS for etcd
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Renewing etcd-server certificate
[upgrade/staticpods] Renewing etcd-peer certificate
[upgrade/staticpods] Renewing etcd-healthcheck-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/etcd.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2024-07-17-21-00-44/etcd.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
[apiclient] Found 1 Pods for label selector component=etcd
[upgrade/staticpods] Component "etcd" upgraded successfully!
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests4119284592"
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Renewing apiserver certificate
[upgrade/staticpods] Renewing apiserver-kubelet-client certificate
[upgrade/staticpods] Renewing front-proxy-client certificate
[upgrade/staticpods] Renewing apiserver-etcd-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-apiserver.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2024-07-17-21-00-44/kube-apiserver.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
[apiclient] Found 1 Pods for label selector component=kube-apiserver
[upgrade/staticpods] Component "kube-apiserver" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Renewing controller-manager.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-controller-manager.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2024-07-17-21-00-44/kube-controller-manager.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
[apiclient] Found 1 Pods for label selector component=kube-controller-manager
[upgrade/staticpods] Component "kube-controller-manager" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Renewing scheduler.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-scheduler.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2024-07-17-21-00-44/kube-scheduler.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
[apiclient] Found 1 Pods for label selector component=kube-scheduler
[upgrade/staticpods] Component "kube-scheduler" upgraded successfully!
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config" in namespace kube-system with the configuration for the kubelets in the cluster
[upgrade] Backing up kubelet config file to /etc/kubernetes/tmp/kubeadm-kubelet-config4248161208/config.yaml
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "super-admin.conf" kubeconfig file
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] Configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] Configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] Configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.29.6". Enjoy!

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
$ sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet=1.29.6-1.1 kubectl=1.29.6-1.1 && sudo apt-mark hold kubelet kubectl
Canceled hold on kubelet.
Canceled hold on kubectl.
Hit:2 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:3 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.29/deb  InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 14 not upgraded.
Need to get 30.4 MB of archives.
After this operation, 250 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.29/deb  kubectl 1.29.6-1.1 [10.5 MB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.29/deb  kubelet 1.29.6-1.1 [19.8 MB]
Fetched 30.4 MB in 1s (25.5 MB/s)
(Reading database ... 60457 files and directories currently installed.)
Preparing to unpack .../kubectl_1.29.6-1.1_amd64.deb ...
Unpacking kubectl (1.29.6-1.1) over (1.29.0-1.1) ...
Preparing to unpack .../kubelet_1.29.6-1.1_amd64.deb ...
Unpacking kubelet (1.29.6-1.1) over (1.29.0-1.1) ...
dpkg: warning: unable to delete old directory '/etc/sysconfig': Directory not empty
Setting up kubelet (1.29.6-1.1) ...

Configuration file '/etc/default/kubelet'
 ==> File on system created by you or by a script.
 ==> File also in package provided by package maintainer.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : start a shell to examine the situation
 The default action is to keep your current version.
*** kubelet (Y/I/N/O/D/Z) [default=N] ? Y
Installing new version of config file /etc/default/kubelet ...
Setting up kubectl (1.29.6-1.1) ...
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

The control plane node should now show the usage of Kubernetes 1.29.6.

```
$ kubectl get nodes
NAME                 STATUS   ROLES           AGE     VERSION
kube-control-plane   Ready    control-plane   10m     v1.29.6
kube-worker-1        Ready    <none>          9m10s   v1.29.0
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

Upgrade kubeadm to version 1.29.6-1.1.

```
$ sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm=1.29.6-1.1 && sudo apt-mark hold kubeadm
Canceled hold on kubeadm.
Hit:2 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:3 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.29/deb  InRelease
Hit:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 15 not upgraded.
Need to get 10.1 MB of archives.
After this operation, 123 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.29/deb  kubeadm 1.29.6-1.1 [10.1 MB]
Fetched 10.1 MB in 1s (12.3 MB/s)
(Reading database ... 60457 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.29.6-1.1_amd64.deb ...
Unpacking kubeadm (1.29.6-1.1) over (1.29.0-1.1) ...
Setting up kubeadm (1.29.6-1.1) ...
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
$ sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet=1.29.6-1.1 kubectl=1.29.6-1.1 && sudo apt-mark hold kubelet kubectl
Canceled hold on kubelet.
Canceled hold on kubectl.
Hit:1 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:3 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:4 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.29/deb  InRelease
Hit:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 14 not upgraded.
Need to get 30.4 MB of archives.
After this operation, 250 kB of additional disk space will be used.
Get:1 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.29/deb  kubectl 1.29.6-1.1 [10.5 MB]
Get:2 https://prod-cdn.packages.k8s.io/repositories/isv:/kubernetes:/core:/stable:/v1.29/deb  kubelet 1.29.6-1.1 [19.8 MB]
Fetched 30.4 MB in 1s (22.9 MB/s)
(Reading database ... 60457 files and directories currently installed.)
Preparing to unpack .../kubectl_1.29.6-1.1_amd64.deb ...
Unpacking kubectl (1.29.6-1.1) over (1.29.0-1.1) ...
Preparing to unpack .../kubelet_1.29.6-1.1_amd64.deb ...
Unpacking kubelet (1.29.6-1.1) over (1.29.0-1.1) ...
dpkg: warning: unable to delete old directory '/etc/sysconfig': Directory not empty
Setting up kubelet (1.29.6-1.1) ...

Configuration file '/etc/default/kubelet'
 ==> File on system created by you or by a script.
 ==> File also in package provided by package maintainer.
   What would you like to do about it ?  Your options are:
    Y or I  : install the package maintainer's version
    N or O  : keep your currently-installed version
      D     : show the differences between the versions
      Z     : start a shell to examine the situation
 The default action is to keep your current version.
*** kubelet (Y/I/N/O/D/Z) [default=N] ? Y
Installing new version of config file /etc/default/kubelet ...
Setting up kubectl (1.29.6-1.1) ...
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

Listing the nodes should now show version 1.29.6 for the worker node.

```
$ kubectl get nodes
NAME                 STATUS     ROLES           AGE   VERSION
kube-control-plane   Ready      control-plane   13m   v1.29.6
kube-worker-1        NotReady   <none>          11m   v1.29.6
```

Exit the worker node.

```
$ exit
```

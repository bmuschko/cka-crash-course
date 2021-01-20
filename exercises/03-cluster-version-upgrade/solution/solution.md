# Solution

You can find a detailed description of the upgrade steps in the [offical Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/).

## Upgrading the Master Node

Shell into the master node.

```
$ vagrant ssh kube-master
```

First, check the nodes and their Kubernetes versions. You will see that all nodes run on version 1.18.0.

```
$ kubectl get nodes
NAME            STATUS   ROLES    AGE     VERSION
kube-master     Ready    master   4m54s   v1.18.0
kube-worker-1   Ready    <none>   3m18s   v1.18.0
```

Install the kubeadm version 1.19.0-00 and check its version.

```
$ sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm=1.19.0-00 && sudo apt-mark hold kubeadm
kubeadm was already not hold.
Hit:2 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:1 https://packages.cloud.google.com/apt kubernetes-xenial InRelease
Hit:3 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
kubeadm is already the newest version (1.19.0-00).
0 upgraded, 0 newly installed, 0 to remove and 7 not upgraded.
kubeadm set on hold.

$ sudo apt-get update && sudo apt-get install -y --allow-change-held-packages kubeadm=1.19.0-00
Hit:2 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:1 https://packages.cloud.google.com/apt kubernetes-xenial InRelease
Hit:3 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:4 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
kubeadm is already the newest version (1.19.0-00).
0 upgraded, 0 newly installed, 0 to remove and 7 not upgraded.

$ kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"19", GitVersion:"v1.19.0", GitCommit:"e19964183377d0ec2052d1f1fa930c4d7575bd50", GitTreeState:"clean", BuildDate:"2020-08-26T14:28:32Z", GoVersion:"go1.15", Compiler:"gc", Platform:"linux/amd64"}
```

Check the available versions.

```
$ sudo kubeadm upgrade plan
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade] Fetching available versions to upgrade to
[upgrade/versions] Cluster version: v1.18.15
[upgrade/versions] kubeadm version: v1.19.0
I0120 15:34:56.928461   24502 version.go:252] remote version is much newer: v1.20.2; falling back to: stable-1.19
[upgrade/versions] Latest stable version: v1.19.7
[upgrade/versions] Latest stable version: v1.19.7
[upgrade/versions] Latest version in the v1.18 series: v1.18.15
[upgrade/versions] Latest version in the v1.18 series: v1.18.15

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   CURRENT       AVAILABLE
kubelet     2 x v1.18.0   v1.19.7

Upgrade to the latest stable version:

COMPONENT                 CURRENT    AVAILABLE
kube-apiserver            v1.18.15   v1.19.7
kube-controller-manager   v1.18.15   v1.19.7
kube-scheduler            v1.18.15   v1.19.7
kube-proxy                v1.18.15   v1.19.7
CoreDNS                   1.6.7      1.7.0
etcd                      3.4.3-0    3.4.9-1

You can now apply the upgrade by executing the following command:

	kubeadm upgrade apply v1.19.7

Note: Before you can perform this upgrade, you have to update kubeadm to v1.19.7.

_____________________________________________________________________


The table below shows the current state of component configs as understood by this version of kubeadm.
Configs that have a "yes" mark in the "MANUAL UPGRADE REQUIRED" column require manual config upgrade or
resetting to kubeadm defaults before a successful upgrade can be performed. The version to manually
upgrade to is denoted in the "PREFERRED VERSION" column.

API GROUP                 CURRENT VERSION   PREFERRED VERSION   MANUAL UPGRADE REQUIRED
kubeproxy.config.k8s.io   v1alpha1          v1alpha1            no
kubelet.config.k8s.io     v1beta1           v1beta1             no
_____________________________________________________________________
```

Apply the upgrade.

```
$ sudo kubeadm upgrade apply v1.19.0
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade/version] You have chosen to change the cluster version to "v1.19.0"
[upgrade/versions] Cluster version: v1.18.15
[upgrade/versions] kubeadm version: v1.19.0
[upgrade/confirm] Are you sure you want to proceed with the upgrade? [y/N]: y
[upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
[upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
[upgrade/prepull] You can also perform this action in beforehand using 'kubeadm config images pull'
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.19.0"...
Static pod: kube-apiserver-kube-master hash: c2a32f0eeb9e14576476cac63ef8d957
Static pod: kube-controller-manager-kube-master hash: fc9c5d63601c989a374026d13f4198fe
Static pod: kube-scheduler-kube-master hash: 76e104b1738c4d035ec548e977a4181c
[upgrade/etcd] Upgrading to TLS for etcd
Static pod: etcd-kube-master hash: 77ee6171b25c192633449c8d706a7e39
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Renewing etcd-server certificate
[upgrade/staticpods] Renewing etcd-peer certificate
[upgrade/staticpods] Renewing etcd-healthcheck-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/etcd.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-01-20-15-36-43/etcd.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: etcd-kube-master hash: 77ee6171b25c192633449c8d706a7e39
Static pod: etcd-kube-master hash: 77ee6171b25c192633449c8d706a7e39
Static pod: etcd-kube-master hash: 291ce002a74a395825e01095938e1d5e
[apiclient] Found 1 Pods for label selector component=etcd
[upgrade/staticpods] Component "etcd" upgraded successfully!
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests181623208"
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Renewing apiserver certificate
[upgrade/staticpods] Renewing apiserver-kubelet-client certificate
[upgrade/staticpods] Renewing front-proxy-client certificate
[upgrade/staticpods] Renewing apiserver-etcd-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-apiserver.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-01-20-15-36-43/kube-apiserver.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: kube-apiserver-kube-master hash: c2a32f0eeb9e14576476cac63ef8d957
Static pod: kube-apiserver-kube-master hash: d60e8f4c7bc5929d02a1d5ac08864411
[apiclient] Found 1 Pods for label selector component=kube-apiserver
[upgrade/staticpods] Component "kube-apiserver" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Renewing controller-manager.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-controller-manager.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-01-20-15-36-43/kube-controller-manager.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: kube-controller-manager-kube-master hash: fc9c5d63601c989a374026d13f4198fe
Static pod: kube-controller-manager-kube-master hash: 4c66648a0ef5ee13f91f2715a8ff7a6b
[apiclient] Found 1 Pods for label selector component=kube-controller-manager
[upgrade/staticpods] Component "kube-controller-manager" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Renewing scheduler.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-scheduler.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2021-01-20-15-36-43/kube-scheduler.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: kube-scheduler-kube-master hash: 76e104b1738c4d035ec548e977a4181c
Static pod: kube-scheduler-kube-master hash: 23d2ea3ba1efa3e09e8932161a572387
[apiclient] Found 1 Pods for label selector component=kube-scheduler
[upgrade/staticpods] Component "kube-scheduler" upgraded successfully!
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.19" in namespace kube-system with the configuration for the kubelets in the cluster
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.19.0". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.
```

Drain the master node by evicting workload.

```
$ kubectl drain kube-master --ignore-daemonsets
node/kube-master cordoned
WARNING: ignoring DaemonSet-managed Pods: kube-system/calico-node-9m74b, kube-system/kube-proxy-qc2fz
evicting pod kube-system/calico-kube-controllers-65f8bc95db-j4p6t
evicting pod kube-system/coredns-f9fd979d6-zfcgz
pod/coredns-f9fd979d6-zfcgz evicted
pod/calico-kube-controllers-65f8bc95db-j4p6t evicted
node/kube-master evicted
```

Upgrade kubelet and kubectl.

```
$ sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet=1.19.0-00 kubectl=1.19.0-00 && sudo apt-mark hold kubelet kubectl
kubelet was already not hold.
kubectl was already not hold.
Hit:2 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:3 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:1 https://packages.cloud.google.com/apt kubernetes-xenial InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease
Hit:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 6 not upgraded.
Need to get 26.6 MB of archives.
After this operation, 4301 kB disk space will be freed.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.19.0-00 [8349 kB]
Get:2 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubelet amd64 1.19.0-00 [18.2 MB]
Fetched 26.6 MB in 4s (6709 kB/s)
(Reading database ... 60579 files and directories currently installed.)
Preparing to unpack .../kubectl_1.19.0-00_amd64.deb ...
Unpacking kubectl (1.19.0-00) over (1.18.0-00) ...
Preparing to unpack .../kubelet_1.19.0-00_amd64.deb ...
Unpacking kubelet (1.19.0-00) over (1.18.0-00) ...
Setting up kubelet (1.19.0-00) ...
Setting up kubectl (1.19.0-00) ...
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
$ kubectl uncordon kube-master
node/kube-master uncordoned
```

The master nodes should now show the usage of Kubernetes 1.19.0.

```
$ kubectl get nodes
NAME            STATUS   ROLES    AGE   VERSION
kube-master     Ready    master   20m   v1.19.0
kube-worker-1   Ready    <none>   19m   v1.18.0
```

Exit the master node.

```
$ exit
```

## Upgrading the Worker Node

Shell into the worker node.

```
$ vagrant ssh kube-worker-1
```

Upgrade kubeadm to version 1.19.0-00.

```
$ sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm=1.19.0-00 && sudo apt-mark hold kubeadm
Canceled hold on kubeadm.
Hit:2 http://security.ubuntu.com/ubuntu bionic-security InRelease
Hit:3 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:1 https://packages.cloud.google.com/apt kubernetes-xenial InRelease
Get:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Fetched 163 kB in 1s (149 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 7 not upgraded.
Need to get 7759 kB of archives.
After this operation, 700 kB disk space will be freed.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.19.0-00 [7759 kB]
Fetched 7759 kB in 1s (9827 kB/s)
(Reading database ... 60579 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.19.0-00_amd64.deb ...
Unpacking kubeadm (1.19.0-00) over (1.18.0-00) ...
Setting up kubeadm (1.19.0-00) ...
kubeadm set on hold.
```

Upgrade the kubelet configuration.

```
$ sudo kubeadm upgrade node
[upgrade] Reading configuration from the cluster...
[upgrade] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -oyaml'
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
WARNING: ignoring DaemonSet-managed Pods: kube-system/calico-node-flzr9, kube-system/kube-proxy-ffq7g
evicting pod kube-system/calico-kube-controllers-65f8bc95db-bsfsc
evicting pod kube-system/coredns-f9fd979d6-rcntb
evicting pod kube-system/coredns-f9fd979d6-xhhbs
pod/calico-kube-controllers-65f8bc95db-bsfsc evicted
pod/coredns-f9fd979d6-xhhbs evicted
pod/coredns-f9fd979d6-rcntb evicted
node/kube-worker-1 evicted
```

Upgrade kubelet and kubectl.

```
$ sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet=1.19.0-00 kubectl=1.19.0-00 && sudo apt-mark hold kubelet kubectl
Canceled hold on kubelet.
Canceled hold on kubectl.
Get:2 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Hit:3 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:1 https://packages.cloud.google.com/apt kubernetes-xenial InRelease
Get:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Fetched 252 kB in 1s (256 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 6 not upgraded.
Need to get 26.6 MB of archives.
After this operation, 4301 kB disk space will be freed.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.19.0-00 [8349 kB]
Get:2 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubelet amd64 1.19.0-00 [18.2 MB]
Fetched 26.6 MB in 2s (12.0 MB/s)
(Reading database ... 60579 files and directories currently installed.)
Preparing to unpack .../kubectl_1.19.0-00_amd64.deb ...
Unpacking kubectl (1.19.0-00) over (1.18.0-00) ...
Preparing to unpack .../kubelet_1.19.0-00_amd64.deb ...
Unpacking kubelet (1.19.0-00) over (1.18.0-00) ...
Setting up kubelet (1.19.0-00) ...
Setting up kubectl (1.19.0-00) ...
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

Listing the nodes should now show version 1.19.0 for the worker node.

```
$ kubectl get nodes
NAME            STATUS   ROLES    AGE   VERSION
kube-master     Ready    master   46m   v1.19.0
kube-worker-1   Ready    <none>   45m   v1.19.0
```

Exit the worker node.

```
$ exit
```
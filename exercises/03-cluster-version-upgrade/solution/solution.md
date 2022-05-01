# Solution

You can find a detailed description of the upgrade steps in the [offical Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-upgrade/).

## Upgrading the Master Node

Shell into the control plane node.

```
$ vagrant ssh kube-control-plane
```

First, check the nodes and their Kubernetes versions. You will see that all nodes run on version 1.22.0.

```
$ kubectl get nodes
NAME                 STATUS   ROLES                  AGE   VERSION
kube-control-plane   Ready    control-plane,master   13m   v1.22.0
kube-worker-1        Ready    <none>                 11m   v1.22.0
```

Install the kubeadm version 1.23.4-00 and check its version.

```
$ sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm=1.23.4-00 && sudo apt-mark hold kubeadm
kubeadm was already not hold.
Get:2 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Hit:3 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:1 https://packages.cloud.google.com/apt kubernetes-xenial InRelease
Get:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Fetched 252 kB in 1s (228 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 81 not upgraded.
Need to get 8583 kB of archives.
After this operation, 627 kB disk space will be freed.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.23.4-00 [8583 kB]
Fetched 8583 kB in 2s (5548 kB/s)
(Reading database ... 60825 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.23.4-00_amd64.deb ...
Unpacking kubeadm (1.23.4-00) over (1.22.0-00) ...
Setting up kubeadm (1.23.4-00) ...
kubeadm set on hold.

$ sudo apt-get update && sudo apt-get install -y --allow-change-held-packages kubeadm=1.23.4-00
Hit:2 https://download.docker.com/linux/ubuntu bionic InRelease
Get:3 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Get:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Hit:1 https://packages.cloud.google.com/apt kubernetes-xenial InRelease
Fetched 252 kB in 3s (76.3 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
kubeadm is already the newest version (1.23.4-00).
0 upgraded, 0 newly installed, 0 to remove and 81 not upgraded.

$ kubeadm version
kubeadm version: &version.Info{Major:"1", Minor:"23", GitVersion:"v1.23.4", GitCommit:"e6c093d87ea4cbb530a7b2ae91e54c0842d8308a", GitTreeState:"clean", BuildDate:"2022-02-16T12:36:57Z", GoVersion:"go1.17.7", Compiler:"gc", Platform:"linux/amd64"}
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
[upgrade/versions] Cluster version: v1.22.9
[upgrade/versions] kubeadm version: v1.23.4
[upgrade/versions] Target version: v1.23.6
[upgrade/versions] Latest version in the v1.22 series: v1.22.9

Components that must be upgraded manually after you have upgraded the control plane with 'kubeadm upgrade apply':
COMPONENT   CURRENT       TARGET
kubelet     2 x v1.22.0   v1.23.6

Upgrade to the latest stable version:

COMPONENT                 CURRENT   TARGET
kube-apiserver            v1.22.9   v1.23.6
kube-controller-manager   v1.22.9   v1.23.6
kube-scheduler            v1.22.9   v1.23.6
kube-proxy                v1.22.9   v1.23.6
CoreDNS                   v1.8.4    v1.8.6
etcd                      3.5.0-0   3.5.1-0

You can now apply the upgrade by executing the following command:

	kubeadm upgrade apply v1.23.6

Note: Before you can perform this upgrade, you have to update kubeadm to v1.23.6.

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
$ sudo kubeadm upgrade apply v1.23.4
[upgrade/config] Making sure the configuration is correct:
[upgrade/config] Reading configuration from the cluster...
[upgrade/config] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
W0430 15:42:42.036071   31381 utils.go:69] The recommended value for "resolvConf" in "KubeletConfiguration" is: /run/systemd/resolve/resolv.conf; the provided value is: /run/systemd/resolve/resolv.conf
[preflight] Running pre-flight checks.
[upgrade] Running cluster health checks
[upgrade/version] You have chosen to change the cluster version to "v1.23.4"
[upgrade/versions] Cluster version: v1.22.9
[upgrade/versions] kubeadm version: v1.23.4
[upgrade/confirm] Are you sure you want to proceed with the upgrade? [y/N]: y
[upgrade/prepull] Pulling images required for setting up a Kubernetes cluster
[upgrade/prepull] This might take a minute or two, depending on the speed of your internet connection
[upgrade/prepull] You can also perform this action in beforehand using 'kubeadm config images pull'
[upgrade/apply] Upgrading your Static Pod-hosted control plane to version "v1.23.4"...
Static pod: kube-apiserver-kube-control-plane hash: 6ebd97c54b6822b4ac0f3641e0e581ec
Static pod: kube-controller-manager-kube-control-plane hash: eb37d244938e273f3aa6175f5915a10a
Static pod: kube-scheduler-kube-control-plane hash: dc3438d2485b25a855f7c2e98ac27019
[upgrade/etcd] Upgrading to TLS for etcd
Static pod: etcd-kube-control-plane hash: a2eb3f88b92abd2beeb8f66af044ee78
[upgrade/staticpods] Preparing for "etcd" upgrade
[upgrade/staticpods] Renewing etcd-server certificate
[upgrade/staticpods] Renewing etcd-peer certificate
[upgrade/staticpods] Renewing etcd-healthcheck-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/etcd.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2022-04-30-15-43-39/etcd.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: etcd-kube-control-plane hash: a2eb3f88b92abd2beeb8f66af044ee78
Static pod: etcd-kube-control-plane hash: a2eb3f88b92abd2beeb8f66af044ee78
Static pod: etcd-kube-control-plane hash: 8c22dc9c444150fa589557fcea1193e7
[apiclient] Found 1 Pods for label selector component=etcd
[upgrade/staticpods] Component "etcd" upgraded successfully!
[upgrade/etcd] Waiting for etcd to become available
[upgrade/staticpods] Writing new Static Pod manifests to "/etc/kubernetes/tmp/kubeadm-upgraded-manifests548921511"
[upgrade/staticpods] Preparing for "kube-apiserver" upgrade
[upgrade/staticpods] Renewing apiserver certificate
[upgrade/staticpods] Renewing apiserver-kubelet-client certificate
[upgrade/staticpods] Renewing front-proxy-client certificate
[upgrade/staticpods] Renewing apiserver-etcd-client certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-apiserver.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2022-04-30-15-43-39/kube-apiserver.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: kube-apiserver-kube-control-plane hash: 6ebd97c54b6822b4ac0f3641e0e581ec
Static pod: kube-apiserver-kube-control-plane hash: 6ebd97c54b6822b4ac0f3641e0e581ec
Static pod: kube-apiserver-kube-control-plane hash: 6ebd97c54b6822b4ac0f3641e0e581ec
Static pod: kube-apiserver-kube-control-plane hash: 6ebd97c54b6822b4ac0f3641e0e581ec
Static pod: kube-apiserver-kube-control-plane hash: f1f2bfaf096c030e284a331d89091c23
[apiclient] Found 1 Pods for label selector component=kube-apiserver
[upgrade/staticpods] Component "kube-apiserver" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-controller-manager" upgrade
[upgrade/staticpods] Renewing controller-manager.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-controller-manager.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2022-04-30-15-43-39/kube-controller-manager.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: kube-controller-manager-kube-control-plane hash: eb37d244938e273f3aa6175f5915a10a
Static pod: kube-controller-manager-kube-control-plane hash: 222f5ec997b9a4ab5f63ec1a451fdc2e
[apiclient] Found 1 Pods for label selector component=kube-controller-manager
[upgrade/staticpods] Component "kube-controller-manager" upgraded successfully!
[upgrade/staticpods] Preparing for "kube-scheduler" upgrade
[upgrade/staticpods] Renewing scheduler.conf certificate
[upgrade/staticpods] Moved new manifest to "/etc/kubernetes/manifests/kube-scheduler.yaml" and backed up old manifest to "/etc/kubernetes/tmp/kubeadm-backup-manifests-2022-04-30-15-43-39/kube-scheduler.yaml"
[upgrade/staticpods] Waiting for the kubelet to restart the component
[upgrade/staticpods] This might take a minute or longer depending on the component/version gap (timeout 5m0s)
Static pod: kube-scheduler-kube-control-plane hash: dc3438d2485b25a855f7c2e98ac27019
Static pod: kube-scheduler-kube-control-plane hash: bac96966489e431d9f3f16bcdb8bc893
[apiclient] Found 1 Pods for label selector component=kube-scheduler
[upgrade/staticpods] Component "kube-scheduler" upgraded successfully!
[upgrade/postupgrade] Applying label node-role.kubernetes.io/control-plane='' to Nodes with label node-role.kubernetes.io/master='' (deprecated)
[upload-config] Storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[kubelet] Creating a ConfigMap "kubelet-config-1.23" in namespace kube-system with the configuration for the kubelets in the cluster
NOTE: The "kubelet-config-1.23" naming of the kubelet ConfigMap is deprecated. Once the UnversionedKubeletConfigMap feature gate graduates to Beta the default name will become just "kubelet-config". Kubeadm upgrade will handle this transition transparently.
[kubelet-start] Writing kubelet configuration to file "/var/lib/kubelet/config.yaml"
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to get nodes
[bootstrap-token] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[bootstrap-token] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[bootstrap-token] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[addons] Applied essential addon: CoreDNS
[addons] Applied essential addon: kube-proxy

[upgrade/successful] SUCCESS! Your cluster was upgraded to "v1.23.4". Enjoy!

[upgrade/kubelet] Now that your control plane is upgraded, please proceed with upgrading your kubelets if you haven't already done so.
```

Drain the master node by evicting workload.

```
$ kubectl drain kube-control-plane --ignore-daemonsets
node/kube-control-plane cordoned
WARNING: ignoring DaemonSet-managed Pods: kube-system/calico-node-r2qc6, kube-system/kube-proxy-pgtcj
evicting pod kube-system/coredns-64897985d-6qldz
evicting pod kube-system/calico-kube-controllers-65898446b5-cjhdq
pod/calico-kube-controllers-65898446b5-cjhdq evicted
pod/coredns-64897985d-6qldz evicted
node/kube-control-plane evicted
```

Upgrade kubelet and kubectl.

```
$ $ sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet=1.23.4-00 kubectl=1.23.4-00 && sudo apt-mark hold kubelet kubectl
kubelet was already not hold.
kubectl was already not hold.
Get:2 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Hit:3 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Hit:1 https://packages.cloud.google.com/apt kubernetes-xenial InRelease
Get:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Fetched 252 kB in 1s (231 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 80 not upgraded.
Need to get 28.4 MB of archives.
After this operation, 29.1 MB disk space will be freed.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.23.4-00 [8927 kB]
Get:2 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubelet amd64 1.23.4-00 [19.5 MB]
Fetched 28.4 MB in 4s (7042 kB/s)
(Reading database ... 60825 files and directories currently installed.)
Preparing to unpack .../kubectl_1.23.4-00_amd64.deb ...
Unpacking kubectl (1.23.4-00) over (1.22.0-00) ...
Preparing to unpack .../kubelet_1.23.4-00_amd64.deb ...
Unpacking kubelet (1.23.4-00) over (1.22.0-00) ...
Setting up kubelet (1.23.4-00) ...
Setting up kubectl (1.23.4-00) ...
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

The control plane node should now show the usage of Kubernetes 1.23.4.

```
$ kubectl get nodes
NAME                 STATUS   ROLES                  AGE   VERSION
kube-control-plane   Ready    control-plane,master   21m   v1.23.4
kube-worker-1        Ready    <none>                 19m   v1.22.0
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

Upgrade kubeadm to version 1.23.4-00.

```
$ sudo apt-mark unhold kubeadm && sudo apt-get update && sudo apt-get install -y kubeadm=1.23.4-00 && sudo apt-mark hold kubeadm
kubeadm was already not hold.
Hit:2 https://download.docker.com/linux/ubuntu bionic InRelease
Hit:3 http://archive.ubuntu.com/ubuntu bionic InRelease
Get:4 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Get:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Hit:1 https://packages.cloud.google.com/apt kubernetes-xenial InRelease
Get:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Fetched 252 kB in 1s (233 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubeadm
1 upgraded, 0 newly installed, 0 to remove and 81 not upgraded.
Need to get 8583 kB of archives.
After this operation, 627 kB disk space will be freed.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubeadm amd64 1.23.4-00 [8583 kB]
Fetched 8583 kB in 1s (6560 kB/s)
(Reading database ... 60825 files and directories currently installed.)
Preparing to unpack .../kubeadm_1.23.4-00_amd64.deb ...
Unpacking kubeadm (1.23.4-00) over (1.22.0-00) ...
Setting up kubeadm (1.23.4-00) ...
kubeadm set on hold.
```

Upgrade the kubelet configuration.

```
$ sudo kubeadm upgrade node
[upgrade] Reading configuration from the cluster...
[upgrade] FYI: You can look at this config file with 'kubectl -n kube-system get cm kubeadm-config -o yaml'
W0430 15:47:43.493866   26496 utils.go:69] The recommended value for "resolvConf" in "KubeletConfiguration" is: /run/systemd/resolve/resolv.conf; the provided value is: /run/systemd/resolve/resolv.conf
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
WARNING: ignoring DaemonSet-managed Pods: kube-system/calico-node-zkblv, kube-system/kube-proxy-9f2r2
evicting pod kube-system/coredns-64897985d-wmmlf
evicting pod kube-system/calico-kube-controllers-65898446b5-phl76
evicting pod kube-system/coredns-64897985d-kzg86
pod/calico-kube-controllers-65898446b5-phl76 evicted
pod/coredns-64897985d-wmmlf evicted
pod/coredns-64897985d-kzg86 evicted
node/kube-worker-1 evicted
```

Upgrade kubelet and kubectl.

```
$ sudo apt-mark unhold kubelet kubectl && sudo apt-get update && sudo apt-get install -y kubelet=1.23.4-00 kubectl=1.23.4-00 && sudo apt-mark hold kubelet kubectl
kubelet was already not hold.
kubectl was already not hold.
Hit:2 https://download.docker.com/linux/ubuntu bionic InRelease
Get:3 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Hit:1 https://packages.cloud.google.com/apt kubernetes-xenial InRelease
Hit:4 http://archive.ubuntu.com/ubuntu bionic InRelease
Get:5 http://archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:6 http://archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Fetched 252 kB in 1s (228 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages will be upgraded:
  kubectl kubelet
2 upgraded, 0 newly installed, 0 to remove and 80 not upgraded.
Need to get 28.4 MB of archives.
After this operation, 29.1 MB disk space will be freed.
Get:1 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubectl amd64 1.23.4-00 [8927 kB]
Get:2 https://packages.cloud.google.com/apt kubernetes-xenial/main amd64 kubelet amd64 1.23.4-00 [19.5 MB]
Fetched 28.4 MB in 4s (7601 kB/s)
(Reading database ... 60825 files and directories currently installed.)
Preparing to unpack .../kubectl_1.23.4-00_amd64.deb ...
Unpacking kubectl (1.23.4-00) over (1.22.0-00) ...
Preparing to unpack .../kubelet_1.23.4-00_amd64.deb ...
Unpacking kubelet (1.23.4-00) over (1.22.0-00) ...
Setting up kubelet (1.23.4-00) ...
Setting up kubectl (1.23.4-00) ...
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

Listing the nodes should now show version 1.23.4 for the worker node.

```
$ kubectl get nodes
NAME                 STATUS   ROLES                  AGE   VERSION
kube-control-plane   Ready    control-plane,master   23m   v1.23.4
kube-worker-1        Ready    <none>                 21m   v1.23.4
```

Exit the worker node.

```
$ exit
```
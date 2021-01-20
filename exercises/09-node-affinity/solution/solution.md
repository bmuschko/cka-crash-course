# Solution

The following solution demonstrates the use of Minikube with a single node cluster. For example, you can start the cluster with three nodes with the command `minikube start --nodes 3` for a brand new cluster or with the command `minikube node add` to add nodes to existing cluster.

First, verify the existing nodes.

```
$ kubectl get nodes --show-labels
NAME           STATUS   ROLES    AGE     VERSION   LABELS
minikube       Ready    master   6m58s   v1.19.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube,kubernetes.io/os=linux,minikube.k8s.io/commit=b09ee50ec047410326a85435f4d99026f9c4f5c4,minikube.k8s.io/name=minikube,minikube.k8s.io/updated_at=2021_01_07T17_20_48_0700,minikube.k8s.io/version=v1.14.0,node-role.kubernetes.io/master=
minikube-m02   Ready    <none>   116s    v1.19.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube-m02,kubernetes.io/os=linux
minikube-m03   Ready    <none>   81s     v1.19.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube-m03,kubernetes.io/os=linux
```

Let's assign the label `color=green` to the node minikube-m02 and the label `color=red` to the node minikube-m03.

```
$ kubectl label nodes minikube-m02 color=green
node/minikube-m02 labeled
$ kubectl label nodes minikube-m03 color=red
node/minikube-m03 labeled
$ kubectl get nodes --show-labels
NAME           STATUS   ROLES    AGE     VERSION   LABELS
minikube       Ready    master   9m3s    v1.19.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube,kubernetes.io/os=linux,minikube.k8s.io/commit=b09ee50ec047410326a85435f4d99026f9c4f5c4,minikube.k8s.io/name=minikube,minikube.k8s.io/updated_at=2021_01_07T17_20_48_0700,minikube.k8s.io/version=v1.14.0,node-role.kubernetes.io/master=
minikube-m02   Ready    <none>   4m1s    v1.19.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,color=green,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube-m02,kubernetes.io/os=linux
minikube-m03   Ready    <none>   3m26s   v1.19.2   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,color=red,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube-m03,kubernetes.io/os=linux
```

The Pod manifest could look as such:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  containers:
  - image: nginx
    name: nginx
  restartPolicy: Never
  nodeSelector:
    color: green
```

Create the Pod and inspect the assigned node.

```
$ kubectl create -f pod.yaml
pod/app created
$ kubectl get pods -o=wide
NAME   READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
app    1/1     Running   0          21s   172.17.0.2   minikube-m02   <none>           <none>
```

Change Pod manifest to use node affinity to schedule it on node minikube-m02 or minikube-m03. The resulting YAML definition would look like this:

```
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  containers:
  - image: nginx
    name: nginx
  restartPolicy: Never
  affinity:
    nodeAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        nodeSelectorTerms:
        - matchExpressions:
          - key: color
            operator: In
            values:
            - green
            - red
```

First delete the Pod, then recreate it. The Pod should be scheduled on one of nodes.

```
$ kubectl create -f pod.yaml
pod/app created
$ kubectl get pods -o=wide
NAME   READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
app    1/1     Running   0          12s   172.17.0.2   minikube-m02   <none>           <none>
```
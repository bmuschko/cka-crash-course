# Solution

The following solution demonstrates the use of a multi-node Minikube cluster. Listing the nodes renders the following output.

```
$ kubectl get nodes
NAME           STATUS   ROLES           AGE     VERSION
minikube       Ready    control-plane   4m6s    v1.24.3
minikube-m02   Ready    <none>          3m28s   v1.24.3
minikube-m03   Ready    <none>          2m51s   v1.24.3
```

Let's assign the label `color=green` to the node minikube-m02 and the label `color=red` to the node minikube-m03.

```
$ kubectl label nodes minikube-m02 color=green
node/minikube-m02 labeled
$ kubectl label nodes minikube-m03 color=red
node/minikube-m03 labeled
```

You can render the assign labels for all nodes using the `--show-labels` command line option.

```
$ kubectl get nodes --show-labels
NAME           STATUS   ROLES           AGE     VERSION   LABELS
minikube       Ready    control-plane   5m25s   v1.24.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube,kubernetes.io/os=linux,minikube.k8s.io/commit=62e108c3dfdec8029a890ad6d8ef96b6461426dc,minikube.k8s.io/name=minikube,minikube.k8s.io/primary=true,minikube.k8s.io/updated_at=2022_09_07T18_06_08_0700,minikube.k8s.io/version=v1.26.1,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
minikube-m02   Ready    <none>          4m47s   v1.24.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,color=green,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube-m02,kubernetes.io/os=linux
minikube-m03   Ready    <none>          4m10s   v1.24.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,color=red,kubernetes.io/arch=amd64,kubernetes.io/hostname=minikube-m03,kubernetes.io/os=linux
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
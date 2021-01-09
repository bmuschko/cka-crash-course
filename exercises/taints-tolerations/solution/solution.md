# Solution

The following solution demonstrates the use of Minikube with a single node cluster. For example, you can start the cluster with three nodes with the command `minikube start --nodes 3` for a brand new cluster or with the command `minikube node add` to add nodes to existing cluster.

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
```

Create the Pod and inspect the assigned node.

```
$ kubectl get nodes
NAME           STATUS   ROLES    AGE   VERSION
minikube       Ready    master   43h   v1.19.2
minikube-m02   Ready    <none>   43h   v1.19.2
minikube-m03   Ready    <none>   43h   v1.19.2
$ kubectl create -f pod.yaml
pod/app created
$ kubectl get pods -o=wide
NAME   READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
app    1/1     Running   0          9s    172.17.0.2   minikube-m03   <none>           <none>
```

Add the taint to the node. In this case, the node is called `minikube-m03`.

```
$ kubectl taint nodes minikube-m03 exclusive=yes:NoExecute
node/minikube-m03 tainted
```

The taint causes the Pod to be evicted.

```
$ kubectl get pods
No resources found in default namespace.
```

Change the Pod manifest and add the toleration.

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
  tolerations:
  - key: "exclusive"
    operator: "Equal"
    value: "yes"
    effect: "NoExecute"
```

With the toleration, the Pod will be allowed to be scheduled on the node `minikube-m03` again.

```
$ kubectl create -f pod.yaml
pod/app created
$ kubectl get pods -o=wide
NAME   READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
app    1/1     Running   0          9s    172.17.0.2   minikube-m03   <none>           <none>
```

Remove the taint from the node. The Pod will continue to run on the node.

```
$ kubectl taint nodes minikube-m03 exclusive-
node/minikube-m03 untainted
$ kubectl get pods -o=wide
NAME   READY   STATUS    RESTARTS   AGE   IP           NODE           NOMINATED NODE   READINESS GATES
app    1/1     Running   0          49m   172.17.0.2   minikube-m03   <none>           <none>
```
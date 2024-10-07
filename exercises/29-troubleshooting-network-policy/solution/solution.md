# Solution

## Fixing the issue in namespace "network"

Create the namespace `network` with the following command:

```
$ kubectl create namespace network
namespace/network created
```

Create all objects :

```
$ kubectl create -f setup.yaml -n network
pod/web-app created
service/web-app-service created
pod/mysql-db created
service/mysql-service created
networkpolicy.networking.k8s.io/default-deny created
```

List all the objects in the namespace.

```
$ kubectl get all -n network
NAME           READY   STATUS    RESTARTS   AGE
pod/mysql-db   1/1     Running   0          66s
pod/web-app    1/1     Running   0          74s

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/mysql-service     ClusterIP   10.96.250.63     <none>        3306/TCP         62s
service/web-app-service   NodePort    10.100.228.112   <none>        3000:32593/TCP   69s
```

Get the IP address of the node. We'll use the IP address for the `curl` command. You can see in the output that there's an issue with the web application exposed by the Service `web-app-service`. The `curl` simply hangs.

```
$ kubectl get nodes -o wide
NAME       STATUS   ROLES           AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE               KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    control-plane   147d   v1.19.2   192.168.64.2   <none>        Buildroot 2019.02.10   4.19.107         docker://19.3.8
$ curl 192.168.64.2:32593 -m 10
curl: (28) Connection timed out after 10004 milliseconds
```

Create a NetworkPolicy allowing traffic from web-app to mysql-db only on port 3306

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: my-policy
spec:
  podSelector:
    matchLabels:
      app: mysql-service
  ingress:
  - ports:
    - port: 3306
  - from:
    - podSelector:
        matchLabels:
          app: web-app
```

You can now connect to the web application via the Service.

```
$ curl 192.168.64.2:32593
Successfully connected to database!
```

Delete the namespace.

```
$ kubectl delete namespace network
namespace "network" deleted
```

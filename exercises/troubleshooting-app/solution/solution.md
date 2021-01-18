# Solution

## Fixing the issue in namepace "gemini"

Create the namespace `gemini` with the following command:

```
$ kubectl create namespace gemini
namespace/gemini created
```

Create all objects with the command `kubectl create -f <yaml-manifest> -n gemini`.

```
$ kubectl create -f web-app-pod.yaml -n gemini
pod/web-app created
$ kubectl create -f web-app-service.yaml -n gemini
service/web-app-service created
$ kubectl create -f mysql-pod.yaml -n gemini
pod/mysql-db created
$ kubectl create -f mysql-service.yaml -n gemini
service/mysql-service created
```

List all the objects in the namespace.

```
$ kubectl get all -n gemini
NAME           READY   STATUS    RESTARTS   AGE
pod/mysql-db   1/1     Running   0          66s
pod/web-app    1/1     Running   0          74s

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/mysql-service     ClusterIP   10.96.250.63     <none>        3306/TCP         62s
service/web-app-service   NodePort    10.100.228.112   <none>        3000:32593/TCP   69s
```

Get the IP address of the node. We'll use the IP address for the `curl` command. You can see in the output that there's an issue with to the web application exposed by the Service `web-app-service`. The `curl` simply hangs.

```
$ kubectl get nodes -o wide
NAME       STATUS   ROLES    AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE               KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    master   147d   v1.19.2   192.168.64.2   <none>        Buildroot 2019.02.10   4.19.107         docker://19.3.8
$ curl 192.168.64.2:32593 -m 10
curl: (28) Connection timed out after 10004 milliseconds
```

Have a look at the details of the `web-app-service`. You will see that no endpoint is listed so something's wrong.

```
$ kubectl describe service/web-app-service -n gemini
Name:                     web-app-service
Namespace:                gemini
Labels:                   app=web-app-service
Annotations:              <none>
Selector:                 run=web-app
Type:                     NodePort
IP:                       10.100.228.112
Port:                     web-app-port  3000/TCP
TargetPort:               3000/TCP
NodePort:                 web-app-port  32593/TCP
Endpoints:                <none>
Session Affinity:         None
External Traffic Policy:  Cluster
Events:                   <none>
```

Upon further inspection, you will find that the Service is using the label selector `run: web-app`, however, the assigned label to the Pod is `app: web-app`.

```
$ kubectl get service web-app-service -o yaml -n gemini | grep -C 1 selector:
    targetPort: 3000
  selector:
    run: web-app
$ kubectl get pod web-app -o yaml -n gemini | grep -C 1 labels:
  creationTimestamp: "2020-11-11T00:05:36Z"
  labels:
    app: web-app
```

Change the label selector by editing the live objects.

```
$ kubectl edit service web-app-service -n gemini
...
  selector:
    app: web-app
...
service/web-app-service edited
```

You can now connect to the web application via the Service.

```
$ curl 192.168.64.2:32593
Successfully connected to database!
```

Delete the namespace.

```
$ kubectl delete namespace gemini
namespace "gemini" deleted
```

## Fixing the issue in namespace "leo"

Create the namespace `leo` with the following command:

```
$ kubectl create namespace leo
namespace/leo created
```

Create all objects with the command `kubectl create -f <yaml-manifest> -n leo`.

```
$ kubectl create -f web-app-pod.yaml -n leo
pod/web-app created
$ kubectl create -f web-app-service.yaml -n leo
service/web-app-service created
$ kubectl create -f mysql-pod.yaml -n leo
pod/mysql-db created
$ kubectl create -f mysql-service.yaml -n leo
service/mysql-service created
```

List all the objects in the namespace.

```
$ kubectl get all -n leo
NAME           READY   STATUS    RESTARTS   AGE
pod/mysql-db   1/1     Running   0          41s
pod/web-app    1/1     Running   0          76s

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
service/mysql-service     ClusterIP   10.110.214.180   <none>        3306/TCP         23s
service/web-app-service   NodePort    10.104.154.79    <none>        3000:31003/TCP   60s
```

Get the IP address of the node. We'll use the IP address for the `curl` command. You can see in the output that there's an issue with the connecting to the database.

```
$ kubectl get nodes -o wide
NAME       STATUS   ROLES    AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE               KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    master   147d   v1.19.2   192.168.64.2   <none>        Buildroot 2019.02.10   4.19.107         docker://19.3.8
$ curl 192.168.64.2:31003
Failed to connect to database: ER_ACCESS_DENIED_ERROR: Access denied for user 'myuser'@'10.0.0.58' (using password: YES)
```

The MySQL Pod does not define a user named `myuser`. The only user that's available is the user named `root`. Therefore, we'll need to change the value of the environment variable `DB_USER` in the `web-app` Pod. Environment variables cannot be changed for a live object. Therefore, the Pod needs to be deleted and recreated.

```
$ kubectl delete pod web-app -n leo
pod "web-app" deleted
$ vim web-app-pod.yaml
...
spec:
  containers:
    ...
    env:
    ...
    - name: DB_USER
      value: root
...
$ kubectl create -f web-app-pod.yaml -n leo
pod/web-app created
$ curl 192.168.64.2:31003
Successfully connected to database!
```

Delete the namespace.

```
$ kubectl delete namespace leo
namespace "leo" deleted
```
# Solution

You should be able to find an Ingress Controller by running the following command in the `kube-system` namespace.

```
$ kubectl get pods -n kube-system
NAME                                        READY   STATUS      RESTARTS   AGE
...
ingress-nginx-controller-799c9469f7-d8whx   1/1     Running     0          4h24m
...
```

Create the Deployment with the following command. Afterward, expose the application with a Service.

```
$ kubectl create deployment web --image=bmuschko/nodejs-hello-world:1.0.0
deployment.apps/web created
$ kubectl get deploy
NAME   READY   UP-TO-DATE   AVAILABLE   AGE
web    1/1     1            1           6s
$ kubectl expose deployment web --type=NodePort --port=3000
service/web exposed
$ kubectl get services
NAME         TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
web          NodePort    10.96.174.197   <none>        3000:30806/TCP   16s
```

Make a call to the application using the `curl` command.

```
$ kubectl get nodes -o wide
NAME       STATUS   ROLES    AGE    VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE               KERNEL-VERSION   CONTAINER-RUNTIME
minikube   Ready    master   192d   v1.19.2   192.168.64.2   <none>        Buildroot 2019.02.10   4.19.107         docker://19.3.8
$ curl 192.168.64.2:30806
Hello World
```

Create an Ingress using the following manifest in the file `ingress.yaml`.

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hello-world-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
    - host: hello-world.exposed
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web
                port:
                  number: 3000
```

Create and list the Ingress.

```
$ kubectl create -f ingress.yaml
ingress.networking.k8s.io/hello-world-ingress created
$ kubectl get ingress
Warning: extensions/v1beta1 Ingress is deprecated in v1.14+, unavailable in v1.22+; use networking.k8s.io/v1 Ingress
NAME                  CLASS    HOSTS                 ADDRESS        PORTS   AGE
hello-world-ingress   <none>   hello-world.exposed   192.168.64.2   80      31s
```

Add the following entry to `/etc/hosts` based on the Ingress' IP address.

```
192.168.64.2 hello-world.exposed
```

Make a call to the endpoint.

```
$ curl hello-world.exposed
Hello World
```
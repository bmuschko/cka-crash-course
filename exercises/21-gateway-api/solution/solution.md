# Solution

## Creating the Deployment and Service

The existing setup YAML manifest creates a Deployment and a Service.

```
$ kubectl apply -f setup.yaml
deployment.apps/web created
service/web created
```

You can render the objects created using the following command.

```
$ kubectl get deployment,service,pod
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/web   1/1     1            1           69m

NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
service/web   ClusterIP   10.104.128.105   <none>        3000/TCP   69m

NAME                       READY   STATUS    RESTARTS   AGE
pod/web-7869b5f9c9-zg9pf   1/1     Running   0          69m
```

## Creating the Gateway API objects

Store the definition of the GatewayClass in the YAML manifest file named [`gateway-class.yaml`](./gateway-class.yaml).

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: GatewayClass
metadata:
  name: envoy
spec:
  controllerName: gateway.envoyproxy.io/gatewayclass-controller
```

Create the GatewayClass object with the following command.

```
$ kubectl apply -f gateway-class.yaml
gatewayclass.gateway.networking.k8s.io/envoy created
```

Store the definition of the Gateway in the YAML manifest file named [`gateway.yaml`](./gateway.yaml).

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: hello-world-gateway
spec:
  gatewayClassName: envoy
  listeners:
    - name: http
      protocol: HTTP
      port: 80
```

Create the Gateway object with the following command.

```
$ kubectl apply -f gateway.yaml
gateway.gateway.networking.k8s.io/hello-world-gateway created
```

Store the definition of the HTTPRoute in the YAML manifest file named [`httproute.yaml`](./httproute.yaml).

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: hello-world-httproute
spec:
  parentRefs:
    - name: hello-world-gateway
  hostnames:
    - "hello-world.exposed"
  rules:
    - backendRefs:
        - group: ""
          kind: Service
          name: web
          port: 3000
          weight: 1
      matches:
        - path:
            type: PathPrefix
            value: /
```

Create the HTTPRoute object with the following command.

```
$ kubectl apply -f httproute.yaml
httproute.gateway.networking.k8s.io/hello-world-httproute created
```

## Accessing the Gateway

Accessing the Gateway differs depending on the Kubernetes cluster you are using. Follow the instructions in the section based on your Kubernetes cluster setup and assumes that you don't have external load balancer support.

Get the name of the Envoy service created the by the example Gateway:

```
$ export ENVOY_SERVICE=$(kubectl get svc -n envoy-gateway-system --selector=gateway.envoyproxy.io/owning-gateway-namespace=default,gateway.envoyproxy.io/owning-gateway-name=hello-world-gateway -o jsonpath='{.items[0].metadata.name}')
```

Port forward to the Envoy service:

```
$ kubectl -n envoy-gateway-system port-forward service/${ENVOY_SERVICE} 8889:80 &
[2] 93490
Forwarding from 127.0.0.1:8889 -> 10080
Forwarding from [::1]:8889 -> 10080
```

### Using Minikube

Minikube requires you to open a tunnel before you can access an gateway. In a new terminal window, run the following command and leave it running.

```
$ minikube tunnel
✅  Tunnel successfully started

📌  NOTE: Please do not close this terminal as this process must stay alive for the tunnel to be accessible ...

❗  The service/ingress envoy-default-hello-world-gateway-b3b341f0 requires privileged ports to be exposed: [80]
🔑  sudo permission will be asked for it.
🏃  Starting tunnel for service envoy-default-hello-world-gateway-b3b341f0.
Password:
```

Edit the file `/etc/hosts` via `sudo vim /etc/hosts`. Add the following entry to map the host name `hello-world.exposed` to the IP address `127.0.0.1`. **Do not use the minikube IP address here, as it is not exposed to the host.**

```
127.0.0.1 hello-world.exposed
```

Make a `curl` call to the host name mapped by the Gateway. The call should be routed toward the backend and respond with the message "Hello World".

```
$ curl hello-world.exposed:8889
Handling connection for 8889
Hello World
```
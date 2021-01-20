# Exercise 12

In this exercise, you will create an Ingress with a simple rule. Make sure your cluster employs an [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/). On Minikube, you can enable the Ingress Controller with the command `minikube addons enable ingress`.

1. Verify that the Ingress Controller is running.
2. Create a new Deployment with the image `bmuschko/nodejs-hello-world:1.0.0`.
3. Expose the Deployment with a Service of type `NodePort` on port 3000.
4. Make a request to the endpoint of the application on the context path `/`. You should see the message "Hello World".
5. Create an Ingress that exposes the path `/` for the host `hello-world.exposed`. The traffic should be routed to the Service created earlier.
6. List the Ingress object.
7. Add an entry in `/etc/hosts` that maps the virtual node IP address to the host `hello-world.exposed`.
8. Make a request to `http://hello-world.exposed`. You should see the message "Hello World".
# Exercise 21

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `default`<br>
* Documentation: [Gateway API](https://gateway-api.sigs.k8s.io/), [Envoy Gateway](https://gateway-api.sigs.k8s.io/implementations/#envoy-gateway)

</p>
</details>

In this exercise, you will create the Gateway objects to define a simple rule that routes traffic to a Service.

> [!IMPORTANT]
> Kubernetes requires the installation of the Gateway API CRDs and Envoy Gateway for the Gateway implementation. You can find installation guidance in the file [gateway-setup.md](./gateway-setup.md).

1. Create the objects from the YAML manifest [setup.yaml](./setup.yaml).
2. Inspect the objects in the namespace `default`.
3. Create a GatewayClass named `envoy` that uses the controller name `gateway.envoyproxy.io/gatewayclass-controller`.
4. Create a Gateway named `hello-world-gateway` with a HTTP listener on port 80. Reference the GatewayClass created in the previous step.
5. Create a HTTPRoute named `hello-world-httproute` to route traffic from the host `hello-world.exposed` to the Service named `web` on port 3000 on the context path `/`.
6. Follow the [Envoy Gateway instructions](https://gateway.envoyproxy.io/docs/tasks/quickstart/#testing-the-configuration) under "Without LoadBalancer Support" before making a `curl` request to `hello-world.exposed`. You should see the message "Hello World".
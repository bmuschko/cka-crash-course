# Setting up Gateway

The Gateway API CRDs do not ship with a Kubernetes cluster. You will have to install them yourself. Run the following command to install the stable release of the CRDs. See the [installation instructions](https://gateway-api.sigs.k8s.io/guides/#installing-gateway-api) for more information.

```
$ kubectl apply -f https://github.com/kubernetes-sigs/gateway-api/releases/download/v1.2.0/standard-install.yaml
customresourcedefinition.apiextensions.k8s.io/gatewayclasses.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/gateways.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/grpcroutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/httproutes.gateway.networking.k8s.io created
customresourcedefinition.apiextensions.k8s.io/referencegrants.gateway.networking.k8s.io created
```

You will now be able to list the CRDs.

```
$ kubectl get crd
NAME                                        CREATED AT
gatewayclasses.gateway.networking.k8s.io    2024-10-05T15:28:20Z
gateways.gateway.networking.k8s.io          2024-10-05T15:28:20Z
grpcroutes.gateway.networking.k8s.io        2024-10-05T15:28:20Z
httproutes.gateway.networking.k8s.io        2024-10-05T15:28:20Z
referencegrants.gateway.networking.k8s.io   2024-10-05T15:28:21Z
```

You will have to [install a Gateway implementation](https://gateway-api.sigs.k8s.io/implementations/) in addition to the Gateway API CRDs. We'll use [Envoy Gateway](https://gateway-api.sigs.k8s.io/implementations/#envoy-gateway) for this example.

```
$ helm install eg oci://docker.io/envoyproxy/gateway-helm --version v1.1.2 -n envoy-gateway-system --create-namespace

Pulled: docker.io/envoyproxy/gateway-helm:v1.1.2
Digest: sha256:71a4a558baef1e1dfc69338276664bcfc34e5f4f33dab2a48f9fd22b8f9f920f
NAME: eg
LAST DEPLOYED: Tue Oct  8 17:20:30 2024
NAMESPACE: envoy-gateway-system
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
**************************************************************************
*** PLEASE BE PATIENT: Envoy Gateway may take a few minutes to install ***
**************************************************************************

Envoy Gateway is an open source project for managing Envoy Proxy as a standalone or Kubernetes-based application gateway.

Thank you for installing Envoy Gateway! 🎉

Your release is named: eg. 🎉

Your release is in namespace: envoy-gateway-system. 🎉

To learn more about the release, try:

  $ helm status eg -n envoy-gateway-system
  $ helm get all eg -n envoy-gateway-system

To have a quickstart of Envoy Gateway, please refer to https://gateway.envoyproxy.io/latest/tasks/quickstart.

To get more details, please visit https://gateway.envoyproxy.io and https://github.com/envoyproxy/gateway.
```

Wait until the Envoy Gateway Deployment is ready to be used.

```
$ kubectl wait --timeout=5m -n envoy-gateway-system deployment/envoy-gateway --for=condition=Available
deployment.apps/envoy-gateway condition met
```
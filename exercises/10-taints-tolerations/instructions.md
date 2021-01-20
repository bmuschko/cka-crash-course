# Exercise 10

In this exercise, you will use the concept of taints and tolerations. First, you'll create a Pod. This Pod will be scheduled on one of the nodes. Next, you will add a taint to the node the Pod is running on and set a toleration effect that evicts the Pod from the node.

1. Define a Pod with the image `nginx` in the YAML manifest file `pod.yaml`
2. Create the Pod and check which node the Pod is running on.
3. Add a taint to the node. Set it to `exclusive: yes`.
4. Modify the live Pod object by adding the following toleration: It should be equal to taint key-value pair and have the effect `NoExecute`.
5. Observe the running behavior of the Pod. If your cluster has more than a single node where do you expect the Pod to run?
6. Remove the taint from the node. Do you expect the Pod to still run on the node?
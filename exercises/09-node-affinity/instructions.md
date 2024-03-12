# Exercise 9

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: `default`<br>
* Documentation: [nodeSelector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector), [Node affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#node-affinity)

</p>
</details>

In this exercise, you will schedule a Pod on a specific node. The Pod should only be scheduled on nodes with the label with the key `color` and the assigned values `green` or `red`.

> [!NOTE]
> Refer to the file [multi-node-cluster-setup.md](../common/multi-node-cluster-setup.md) to configure a cluster with multiple nodes.

1. Inspect the existing nodes and their assigned labels.
2. Pick one available node and label it with the key-value pair `color=green`. Pick a second node and label it with the key-value pair `color=red`.
3. Define a Pod with the image `nginx` in the YAML manifest file `pod.yaml`. Use the `nodeSelector` assignment to schedule the Pod on the node with the label `color=green`.
4. Create the Pod and ensure that the correct node has been used to run the Pod.
5. Change the Pod definition to schedule it on nodes with the label `color=green` or `color=red`.
6. Verify that the Pod runs on the correct node.
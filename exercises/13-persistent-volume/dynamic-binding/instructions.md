# Exercise 13

In this exercise, you will create a PersistentVolume using dynamic binding and mount it to a Pod.

1. List all the storage class objects in the `default` namespace.
2. If you are trying out dynamic binding, then create a new storage class with appropriate settings for your Kubernetes environment. Name the storage class object `custom`. On Minikube, use the provisioner `k8s.io/minikube-hostpath`. Assign the annotation `storageclass.beta.kubernetes.io/is-default-class: "false"` and the label `addonmanager.kubernetes.io/mode: Reconcile`.
3. Create a PersistentVolumeClaim named `pvc` with the storage class named `custom` if created in the previous step. The claim should request 256MB. Ensure that the PersistentVolumeClaim is properly bound after its creation.
4. Mount the PersistentVolumeClaim from a new Pod named `app` with the path `/var/app/config`. The Pod uses the image `nginx`.
5. Open an interactive shell to the Pod and create a file in the directory `/var/app/config`.
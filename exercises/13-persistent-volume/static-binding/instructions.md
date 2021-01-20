# Exercise 13

In this exercise, you will create a PersistentVolume using static binding and mount it to a Pod.

1. Create a PersistentVolume named `pv`, access mode `ReadWriteMany`, 512MB of storage capacity and the host path `/data/config`.
2. Create a PersistentVolumeClaim named `pvc`. The claim should request 256MB. Ensure that the PersistentVolumeClaim is properly bound after its creation.
3. Mount the PersistentVolumeClaim from a new Pod named `app` with the path `/var/app/config`. The Pod uses the image `nginx`.
4. Open an interactive shell to the Pod and create a file in the directory `/var/app/config`.
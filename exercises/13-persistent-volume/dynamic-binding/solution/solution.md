# Solution

List the existing storage classes. You will find that MiniKube already creates a default storage class for you.

```
$ kubectl get storageclass
NAME                 PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
standard (default)   k8s.io/minikube-hostpath   Delete          Immediate           false                  197d
```

Define a new storage class in a manifest file named `storageclass.yaml`. 

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
  namespace: kube-system
  name: custom
  annotations:
    storageclass.beta.kubernetes.io/is-default-class: "false"
  labels:
    addonmanager.kubernetes.io/mode: Reconcile
provisioner: k8s.io/minikube-hostpath
```

Create the storage class and verify that it was created.

```
$ kubectl create -f storageclass.yaml
storageclass.storage.k8s.io/custom created
$ kubectl get storageclass
NAME                 PROVISIONER                RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
custom               k8s.io/minikube-hostpath   Delete          Immediate           false                  7s
standard (default)   k8s.io/minikube-hostpath   Delete          Immediate           false                  197d
```

Create a manifest for the PersistentVolumeClaim and store it in the file `pvc.yaml`.

```yaml
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: pvc
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 256m
  storageClassName: custom
```

Create the PersistentVolumeClaim with the following command. You will see that the storage class assigned to the PersistentVolumeClaim. Listing the PersistentVolumes will also reveal that the object has been created for your automatically.

```
$ kubectl create -f pvc.yaml
persistentvolumeclaim/pvc created
$ kubectl get pvc
NAME   STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
pvc    Bound    pvc-e55399e7-2f49-443e-8fd9-659588b01071   256m       RWX            custom         22s
$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM         STORAGECLASS   REASON   AGE
pvc-e55399e7-2f49-443e-8fd9-659588b01071   256m       RWX            Delete           Bound    default/pvc   custom                  21m
```

Create a manifest for the Pod and store it in the file `pod.yaml`.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  containers:
  - image: nginx
    name: app
    volumeMounts:
    - mountPath: "/data/app/config"
      name: configpvc
  volumes:
  - name: configpvc
    persistentVolumeClaim:
      claimName: pvc
  restartPolicy: Never
```

```
$ kubectl create -f pod.yaml
pod/app created
```

Shell into the Pod and create a file in the mounted directory.

```
$ kubectl exec app -it -- /bin/sh
# cd /data/app/config
# ls -l
total 0
# touch test.txt
# ls -l
total 0
-rw-r--r-- 1 root root 0 Dec 30 17:24 test.txt
```
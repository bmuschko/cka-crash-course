# Solution

Open an interactive shell to the control plane node.

```
$ vagrant ssh kube-control-plane
```

You can see that none of the Pods controlled by the Deployment could be scheduled. They are all in the "Pending" status. The events of any of the Pods do not reveal any helpful information.

```
$ kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
deploy-6b677fb8f7-4hs4d   0/1     Pending   0          7m28s
deploy-6b677fb8f7-k69nk   0/1     Pending   0          7m28s
deploy-6b677fb8f7-vjth2   0/1     Pending   0          7m28s

$ kubectl describe pod deploy-6b677fb8f7-4hs4d
...
Events:          <none>
```

The Pod running the Kubernetes scheduler reports an issue indicated by the "CrashLoopBackOff" status. Apparently, something's wrong with it. The events of the Pod only confirm that it has been restarted multiple times.

```
$ kubectl get pods -n kube-system
NAME                                         READY   STATUS             RESTARTS      AGE
coredns-7c65d6cfc9-78p96                     1/1     Running            0             17m
coredns-7c65d6cfc9-n2hsj                     1/1     Running            0             17m
etcd-kube-control-plane                      1/1     Running            0             17m
kube-apiserver-kube-control-plane            1/1     Running            0             17m
kube-controller-manager-kube-control-plane   1/1     Running            0             17m
kube-proxy-cfsns                             1/1     Running            0             17m
kube-scheduler-kube-control-plane            0/1     CrashLoopBackOff   8 (53s ago)   17m

$ kubectl describe pod kube-scheduler-kube-control-plane -n kube-system
...
Events:
  Type     Reason   Age                    From     Message
  ----     ------   ----                   ----     -------
  Normal   Created  5m31s (x4 over 6m17s)  kubelet  Created container kube-scheduler
  Normal   Started  5m31s (x4 over 6m17s)  kubelet  Started container kube-scheduler
  Normal   Pulled   4m50s (x5 over 6m17s)  kubelet  Container image "registry.k8s.io/kube-scheduler:v1.31.9" already present on machine
  Warning  BackOff  63s (x32 over 6m15s)   kubelet  Back-off restarting failed container kube-scheduler in pod kube-scheduler-kube-control-plane_kube-system(bd324109542e6c0b3fc9cff874e17b74)
```

The logs of the Pod are more helpful. It looks like its configuration points to a file or directory that doesn't exist.

```
$ kubectl logs kube-scheduler-kube-control-plane -n kube-system
E0526 01:22:45.322797       1 run.go:72] "command failed" err="failed to get delegated authentication kubeconfig: failed to get delegated authentication kubeconfig: stat /etc/kubernetes/scheduler-authentication.conf: no such file or directory"
```

Check the file `/etc/kubernetes/scheduler-authentication.conf`. It does not exist but there's a file which points to a file that doesn't exist: `/etc/kubernetes/scheduler.conf`.

```
$ ls /etc/kubernetes/scheduler-authentication.conf
ls: cannot access '/etc/kubernetes/scheduler-authentication.conf': No such file or directory
$ ls /etc/kubernetes
admin.conf  controller-manager.conf  kubelet.conf  manifests  pki  scheduler.conf  super-admin.conf
```

Let's point to it by changing the configuration of the scheduler in `/etc/kubernetes/manifests/kube-scheduler.yaml`. Change the value of the command line option `--authentication-kubeconfig` from the value `/etc/kubernetes/scheduler-authentication.conf` to `/etc/kubernetes/scheduler.conf`.

```
$ sudo vim /etc/kubernetes/manifests/kube-scheduler.yaml
...
spec:
  containers:
  - command:
    - kube-scheduler
    - --authentication-kubeconfig=/etc/kubernetes/scheduler.conf
...
```

After saving the change, the Pod `kube-scheduler-kube-control-plane` will be restarted.

```
$ kubectl get pods -n kube-system
NAME                                READY   STATUS    RESTARTS   AGE
kube-scheduler-kube-control-plane   1/1     Running   0          73s
```

Once the Pod transitions into the "Running" status, the scheduler should take care of scheduling the Pods of the Deployment `deploy`.

```
$ kubectl get pods
NAME                      READY   STATUS    RESTARTS   AGE
deploy-6b677fb8f7-4hs4d   1/1     Running   0          24m
deploy-6b677fb8f7-k69nk   1/1     Running   0          24m
deploy-6b677fb8f7-vjth2   1/1     Running   0          24m
```

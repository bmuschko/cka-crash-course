# Solution

You can see that none of the Pod controlled by the Deployment could be scheduled. They are all in the "Pending" status. The events of the any of the Pods do not reveal any helpful information.

```
$ kubectl get deployments,pods
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/deploy   0/3     3            0           7m36s

NAME                          READY   STATUS    RESTARTS   AGE
pod/deploy-6b677fb8f7-4hs4d   0/1     Pending   0          7m28s
pod/deploy-6b677fb8f7-k69nk   0/1     Pending   0          7m28s
pod/deploy-6b677fb8f7-vjth2   0/1     Pending   0          7m28s

$ kubectl describe pod/deploy-6b677fb8f7-4hs4d
...
Events:          <none>
```

The Pod running the Kubernetes scheduler reports an issue indicated by the "CrashLoopBackOff" status. Apparently, something's wrong with it. The events of the Pod only confirm that it has been restarted multiple times.

```
$ kubectl get pods -n kube-system
NAME                                       READY   STATUS             RESTARTS   AGE
calico-kube-controllers-6dfcd885bf-vgn62   0/1     Pending            0          7m41s
calico-node-2pj9b                          0/1     Pending            0          5m2s
calico-node-5jg9j                          0/1     Pending            0          6m21s
calico-node-f84rt                          0/1     Pending            0          7m41s
coredns-74ff55c5b-8j2z2                    0/1     Pending            0          7m41s
coredns-74ff55c5b-sn5zw                    0/1     Pending            0          7m41s
etcd-kube-master                           1/1     Running            0          7m54s
kube-apiserver-kube-master                 1/1     Running            0          7m54s
kube-controller-manager-kube-master        1/1     Running            0          7m54s
kube-proxy-k7sbw                           0/1     Pending            0          7m41s
kube-proxy-wlzbw                           0/1     Pending            0          5m2s
kube-proxy-z8tvs                           0/1     Pending            0          6m21s
kube-scheduler-kube-master                 0/1     CrashLoopBackOff   6          7m49s

$ kubectl describe pod kube-scheduler-kube-master -n kube-system
...
Events:
  Type     Reason   Age                 From     Message
  ----     ------   ----                ----     -------
  Normal   Pulled   14m (x5 over 15m)   kubelet  Container image "k8s.gcr.io/kube-scheduler:v1.20.2" already present on machine
  Normal   Created  14m (x5 over 15m)   kubelet  Created container kube-scheduler
  Normal   Started  14m (x5 over 15m)   kubelet  Started container kube-scheduler
  Warning  BackOff  34s (x75 over 15m)  kubelet  Back-off restarting failed container
```

The logs of the Pod are more helpful. It looks like its configuration points to a file or directory that doesn't exist.

```
$ kubectl logs kube-scheduler-kube-master -n kube-system
I0121 21:44:46.227895       1 serving.go:331] Generated self-signed cert in-memory
failed to get delegated authentication kubeconfig: failed to get delegated authentication kubeconfig: stat /etc/kubernetes/scheduler-authentication.conf: no such file or directory
```

Check the file `/etc/kubernetes/scheduler-authentication.conf`. It does exist but there's a file which sounds right: `/etc/kubernetes/scheduler.conf`. Let's point to it by changing the configuration of the scheduler in `/etc/kubernetes/manifests/kube-scheduler.yaml`. Change the value of the command line option `--authentication-kubeconfig`.

```
$ ls /etc/kubernetes/scheduler-authentication.conf
ls: cannot access '/etc/kubernetes/scheduler-authentication.conf': No such file or directory
$ ls /etc/kubernetes
admin.conf  controller-manager.conf  kubelet.conf  manifests  pki  scheduler.conf
$ sudo vim /etc/kubernetes/manifests/kube-scheduler.yaml
```

After saving the change, the Pod `kube-scheduler-kube-master` will be restarted.

```
$ kubectl get pods -n kube-system
NAME                                       READY   STATUS    RESTARTS   AGE
kube-scheduler-kube-master                 1/1     Running   0          73s
```

Once the Pod transitions into the "Running" status, the scheduler should take care of scheduling the Pods of the Deployment `deploy`.

```
$ kubectl get deployments,pods
NAME                     READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/deploy   3/3     3            3           25m

NAME                          READY   STATUS    RESTARTS   AGE
pod/deploy-6b677fb8f7-4hs4d   1/1     Running   0          24m
pod/deploy-6b677fb8f7-k69nk   1/1     Running   0          24m
pod/deploy-6b677fb8f7-vjth2   1/1     Running   0          24m
```
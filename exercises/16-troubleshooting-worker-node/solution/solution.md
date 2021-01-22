# Solution

Shell into the master node with the following command.

```
$ vagrant ssh kube-master
```

Have a look at the status of the nodes. The worker node has an issue indicated by "NotReady".

```
$ kubectl get nodes
NAME            STATUS     ROLES                  AGE     VERSION
kube-master     Ready      control-plane,master   2m52s   v1.20.2
kube-worker-1   NotReady   <none>                 85s     v1.20.2
```

The events of the worker node to not expose any apparent issues.

```
$ kubectl describe node kube-worker-1
...
Events:
  Type    Reason                   Age                    From     Message
  ----    ------                   ----                   ----     -------
  Normal  Starting                 4m15s                  kubelet  Starting kubelet.
  Normal  NodeHasSufficientMemory  4m15s (x2 over 4m15s)  kubelet  Node kube-worker-1 status is now: NodeHasSufficientMemory
  Normal  NodeHasNoDiskPressure    4m15s (x2 over 4m15s)  kubelet  Node kube-worker-1 status is now: NodeHasNoDiskPressure
  Normal  NodeHasSufficientPID     4m15s (x2 over 4m15s)  kubelet  Node kube-worker-1 status is now: NodeHasSufficientPID
  Normal  NodeAllocatableEnforced  4m15s                  kubelet  Updated Node Allocatable limit across pods
```

Exit the master node and shell into the worker node.

```
$ exit
$ vagrant ssh kube-worker-1
```

The `journalctl` can provide useful information about the service. It looks like the client CA file is misconfigured.

```
$ sudo journalctl -u kubelet.service
Jan 21 23:46:49 kube-worker-1 kubelet[6560]: F0121 23:46:49.183791    6560 server.go:257] unable to load client CA file /etc/kubernetes/pki/non-existent-ca.crt: open /etc/kubernetes/pki/non-existent-ca.crt: no such file or directory
```

The configuration file can be discovered by rendering the status of the service. The drop-in value points to `/etc/systemd/system/kubelet.service.d/10-kubeadm.conf`.

```
$ systemctl status kubelet.service -l
● kubelet.service - kubelet: The Kubernetes Node Agent
   Loaded: loaded (/lib/systemd/system/kubelet.service; enabled; vendor preset: enabled)
  Drop-In: /etc/systemd/system/kubelet.service.d
           └─10-kubeadm.conf
   Active: activating (auto-restart) (Result: exit-code) since Fri 2021-01-22 00:01:31 UTC; 9s ago
     Docs: https://kubernetes.io/docs/home/
  Process: 9644 ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS (code=exited, status=255)
 Main PID: 9644 (code=exited, status=255)
 
$ sudo cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
# Note: This dropin only works with kubeadm and kubelet v1.11+
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
# This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
# This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
# the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
EnvironmentFile=-/etc/default/kubelet
ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
```

The value of the environment variable `KUBELET_CONFIG_ARGS` is `--config=/var/lib/kubelet/config.yaml`. Let's fix the file by changing to `clientCAFile: /etc/kubernetes/pki/ca.crt`.

```
$ sudo ls /etc/kubernetes/pki
ca.crt
$ sudo vim /var/lib/kubelet/config.yaml
```

Now, let's restart the service.

```
$ sudo systemctl daemon-reload
$ sudo systemctl restart kubelet
```

The worker node should transition into the "Ready" status.

```
$ kubectl get nodes
NAME            STATUS   ROLES                  AGE   VERSION
kube-master     Ready    control-plane,master   21m   v1.20.2
kube-worker-1   Ready    <none>                 20m   v1.20.2
```
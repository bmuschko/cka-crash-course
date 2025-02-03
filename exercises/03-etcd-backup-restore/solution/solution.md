# Solution

Open an interactive shell to the control plane node.

```
$ vagrant ssh kube-control-plane
```

## Creating the Backup

Etcd is deployed as a Pod in the `kube-system` namespace. Inspect the version by describing the Pod. In the output below, you will find that the version is 3.5.15-0

```
$ kubectl get pods -n kube-system
NAME                      READY   STATUS    RESTARTS   AGE
...
etcd-kube-control-plane   1/1     Running   0          8m51s
...
$ kubectl describe pod etcd-kube-control-plane -n kube-system
...
Containers:
  etcd:
    Container ID:  containerd://cbd632b3c727a05dbaaefef577ce9c7d8d64fc1807068d889585699c560a39ad
    Image:         registry.k8s.io/etcd:3.5.15-0
    Image ID:      registry.k8s.io/etcd@sha256:a6dc63e6e8cfa0307d7851762fa6b629afb18f28d8aa3fab5a6e91b4af60026a
...
```

The same `describe` command reveals the configuration of the etcd service. Look for the value of the option `--listen-client-urls` for the endpoint URL. In the output below, the host is `localhost` and the port is `2379`. The server certificate is located at `/etc/kubernetes/pki/etcd/server.crt` defined by the option `--cert-file`. The CA certificate can be found at `/etc/kubernetes/pki/etcd/ca.crt` specified by the option `--trusted-ca-file`.

```
$ kubectl describe pod etcd-kube-control-plane -n kube-system
...
Containers:
  etcd:
    ...
    Command:
      etcd
      ...
      --cert-file=/etc/kubernetes/pki/etcd/server.crt
      --listen-client-urls=https://127.0.0.1:2379,https://192.168.56.10:2379
      --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
...
```

Use the `etcdctl` command to create the backup with version 3 of the tool. For a good starting point, copy the command from the [official Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#built-in-snapshot). Provide the mandatory command line options `--cacert`, `--cert`, and `--key`. The option `--endpoints` is not needed as we are running the command on the same server as etcd. After running the command, the file `/tmp/etcd-backup.db` has been created.

```
$ sudo ETCDCTL_API=3 etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /opt/etcd-backup.db
{"level":"info","ts":"2025-01-30T18:52:16.059213Z","caller":"snapshot/v3_snapshot.go:65","msg":"created temporary db file","path":"/opt/etcd-backup.db.part"}
{"level":"info","ts":"2025-01-30T18:52:16.063272Z","logger":"client","caller":"v3@v3.5.15/maintenance.go:212","msg":"opened snapshot stream; downloading"}
{"level":"info","ts":"2025-01-30T18:52:16.063396Z","caller":"snapshot/v3_snapshot.go:73","msg":"fetching snapshot","endpoint":"127.0.0.1:2379"}
{"level":"info","ts":"2025-01-30T18:52:16.099691Z","logger":"client","caller":"v3@v3.5.15/maintenance.go:220","msg":"completed snapshot read; closing"}
{"level":"info","ts":"2025-01-30T18:52:16.102233Z","caller":"snapshot/v3_snapshot.go:88","msg":"fetched snapshot","endpoint":"127.0.0.1:2379","size":"5.6 MB","took":"now"}
{"level":"info","ts":"2025-01-30T18:52:16.102278Z","caller":"snapshot/v3_snapshot.go:97","msg":"saved","path":"/opt/etcd-backup.db"}
Snapshot saved at /opt/etcd-backup.db
```

## Restoring Data from the Backup

To restore etcd from the backup, use the `etcdutl` command. At a minimum, provide the `--data-dir` command line option. Here, we are using the data directory `/tmp/from-backup`. After running the command, you should be able to find the restored backup in the directory `/var/lib/from-backup`.

```
$ sudo ETCDCTL_API=3 etcdutl --data-dir=/var/lib/from-backup snapshot restore /opt/etcd-backup.db
2025-01-30T18:52:37Z	info	snapshot/v3_snapshot.go:265	restoring snapshot	{"path": "/opt/etcd-backup.db", "wal-dir": "/var/lib/from-backup/member/wal", "data-dir": "/var/lib/from-backup", "snap-dir": "/var/lib/from-backup/member/snap", "initial-memory-map-size": 10737418240}
2025-01-30T18:52:37Z	info	membership/store.go:141	Trimming membership information from the backend...
2025-01-30T18:52:37Z	info	membership/cluster.go:421	added member	{"cluster-id": "cdf818194e3a8c32", "local-member-id": "0", "added-peer-id": "8e9e05c52164694d", "added-peer-peer-urls": ["http://localhost:2380"]}
2025-01-30T18:52:37Z	info	snapshot/v3_snapshot.go:293	restored snapshot	{"path": "/opt/etcd-backup.db", "wal-dir": "/var/lib/from-backup/member/wal", "data-dir": "/var/lib/from-backup", "snap-dir": "/var/lib/from-backup/member/snap", "initial-memory-map-size": 10737418240}
member
```

Edit the YAML manifest of the etcd Pod which can be found at `/etc/kubernetes/manifests/etcd.yaml`. Change the value of the attribute `spec.volumes.hostPath` with the name `etcd-data` from the original value `/var/lib/etcd` to `/var/lib/from-backup`.

```
$ sudo vim /etc/kubernetes/manifests/etcd.yaml
...
spec:
  volumes:
  ...
  - hostPath:
      path: /var/lib/from-backup
      type: DirectoryOrCreate
    name: etcd-data
...
```

The `etcd-kube-control-plane` Pod will be recreated and points to the restored backup directory.

```
$ kubectl get pod etcd-kube-control-plane -n kube-system
NAME                      READY   STATUS    RESTARTS   AGE
etcd-kube-control-plane   1/1     Running   0          5m1s
```

In case the Pod doesn't transition into the "Running" status, try deleting it manually with the command `kubectl delete pod etcd-kube-control-plane -n kube-system`.

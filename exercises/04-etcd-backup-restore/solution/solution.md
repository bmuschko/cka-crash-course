Etcd is deployed as a Pod in the `kube-system` namespace. Inspect the version by describing the Pod. In the output below, you will find that the version is 3.4.13-0.

```
$ kubectl get pods -n kube-system
NAME                 READY   STATUS    RESTARTS   AGE
...
etcd-kube-master     1/1     Running   0          8m51s
...
$ kubectl describe pod etcd-kube-master -n kube-system
...
Containers:
  etcd:
    Container ID:  docker://bcd9f2368a91815fcef92c5f543f33854ac8829d602c9774a9e75ae73a5007bc
    Image:         k8s.gcr.io/etcd:3.4.13-0
    Image ID:      docker-pullable://k8s.gcr.io/etcd@sha256:4ad90a11b55313b182afc186b9876c8e891531b8db4c9bf1541953021618d0e2
...
```

The same `describe` command reveals the configuration of the etcd service. Look for the value of the option `--listen-client-urls` for the endpoint URL. In the output below, the host is `localhost` and the port is `2379`. The server certificate is located at `/etc/kubernetes/pki/etcd/server.crt` defined by the option `--cert-file`. The CA certificate can be found at `/etc/kubernetes/pki/etcd/ca.crt` specified by the option `--trusted-ca-file`.

```
$ kubectl describe pod etcd-kube-master -n kube-system
...
Containers:
  etcd:
    ...
    Command:
      etcd
      ...
      --cert-file=/etc/kubernetes/pki/etcd/server.crt
      --listen-client-urls=https://127.0.0.1:2379,https://10.8.8.10:2379
      --trusted-ca-file=/etc/kubernetes/pki/etcd/ca.crt
...
```

Use the `etcdctl` command to create the backup with version 3 of the tool. For a good starting point, copy the command from the [official Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#built-in-snapshot). Provide the mandatory command line options `--cacert`, `--cert`, and `--key`. The option `--endpoints` is not needed as we are running the command on the same server as etcd. After running the command, the file `/tmp/etcd-backup.db` has been created.

```
$ sudo ETCDCTL_API=3 etcdctl --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key snapshot save /opt/etcd-backup.db
{"level":"info","ts":1611088638.0990849,"caller":"snapshot/v3_snapshot.go:119","msg":"created temporary db file","path":"/opt/etcd-backup.db.part"}
{"level":"info","ts":"2021-01-19T20:37:18.105Z","caller":"clientv3/maintenance.go:200","msg":"opened snapshot stream; downloading"}
{"level":"info","ts":1611088638.1057441,"caller":"snapshot/v3_snapshot.go:127","msg":"fetching snapshot","endpoint":"127.0.0.1:2379"}
{"level":"info","ts":"2021-01-19T20:37:18.164Z","caller":"clientv3/maintenance.go:208","msg":"completed snapshot read; closing"}
{"level":"info","ts":1611088638.2264123,"caller":"snapshot/v3_snapshot.go:142","msg":"fetched snapshot","endpoint":"127.0.0.1:2379","size":"3.5 MB","took":0.127257765}
{"level":"info","ts":1611088638.227194,"caller":"snapshot/v3_snapshot.go:152","msg":"saved","path":"/opt/etcd-backup.db"}
Snapshot saved at /opt/etcd-backup.db
```

To restore etcd from the backup, use the `etcdctl` command. At a minimum, provide the `--data-dir` command line option. Here, we are using the data directory `/tmp/from-backup`. After running the command, you should be able to find the restored backup in the directory `/var/lib/from-backup`.

```
$ sudo ETCDCTL_API=3 etcdctl --data-dir=/var/lib/from-backup snapshot restore /opt/etcd-backup.db
{"level":"info","ts":1611088702.6165962,"caller":"snapshot/v3_snapshot.go:296","msg":"restoring snapshot","path":"/opt/etcd-backup.db","wal-dir":"/var/lib/from-backup/member/wal","data-dir":"/var/lib/from-backup","snap-dir":"/var/lib/from-backup/member/snap"}
{"level":"info","ts":1611088702.6666403,"caller":"mvcc/kvstore.go:380","msg":"restored last compact revision","meta-bucket-name":"meta","meta-bucket-name-key":"finishedCompactRev","restored-compact-revision":27124}
{"level":"info","ts":1611088702.6746597,"caller":"membership/cluster.go:392","msg":"added member","cluster-id":"cdf818194e3a8c32","local-member-id":"0","added-peer-id":"8e9e05c52164694d","added-peer-peer-urls":["http://localhost:2380"]}
{"level":"info","ts":1611088702.692672,"caller":"snapshot/v3_snapshot.go:309","msg":"restored snapshot","path":"/opt/etcd-backup.db","wal-dir":"/var/lib/from-backup/member/wal","data-dir":"/var/lib/from-backup","snap-dir":"/var/lib/from-backup/member/snap"}
$ sudo ls /var/lib/from-backup
member
```

Edit the YAML manifest of the etcd Pod which can be found at `/etc/kubernetes/manifests/etcd.yaml`. Change the value of the attribute `spec.volumes.hostPath` with the name `etcd-data` from the original value `/var/lib/etcd` to `/var/lib/from-backup`.

```
$ cd /etc/kubernetes/manifests/
$ sudo vim etcd.yaml
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

The `etcd-kube-master` Pod will be recreated and points to the restored backup directory.

```
$ kubectl get pod etcd-kube-master -n kube-system
NAME               READY   STATUS    RESTARTS   AGE
etcd-kube-master   1/1     Running   0          5m1s
```

In case the Pod doesn't transition into the "Running" status, try deleting it manually with the command `kubectl delete pod etcd-kube-master -n kube-system`.
# Exercise 3

<details>
<summary><b>Quick Reference</b></summary>
<p>

* Namespace: N/A<br>
* Documentation: [Backing up an etcd cluster](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/#backing-up-an-etcd-cluster)

</p>
</details>

In this exercise, you will identify the configuration of the etcd database, back it up and restore the original database from a backup file. The command line tools `etcdctl` and `etcdutl` have already been pre-installed on the control plane node.

> [!NOTE]
> The file [vagrant-setup.md](../common/vagrant-setup.md) describes the setup instructions and commands for Vagrant and VMware. If you do not want to use the Vagrant environment, you can use the O'Reilly interactive lab ["Backing up and restoring etcd"](https://learning.oreilly.com/scenarios/cka-prep-backing/9781492095521/).

1. Shell into control plane node using the command `vagrant ssh kube-control-plane`.
2. Check that all nodes have been correctly registered and are in the "Ready" status.
3. Find out the version of etcd running in the cluster.
4. Identify the endpoint URL for the etcd service, the location of the server certificate and the location of the CA certificate.
5. Create a snapshot of the etcd database. Store the backup in the file `/opt/etcd-backup.db`.
6. Restore the original state of the cluster from the backup file at `/opt/etcd-backup.db` to the directory `/var/lib/from-backup`.
7. Point etcd to the new directory containing the restored backup. Restart the etcd Pod.

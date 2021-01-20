# Exercise 4

In this exercise, you will identify the configuration of the etcd database, back it up and restore the original database from a backup file. The command line tool `etcdctl` has already been pre-installed on the master node.

Start the VMs using the command `vagrant up`. Depending on the hardware and network connectivity of your machine, this process may take a couple of minutes. After you are done with the exercise, shut down the VMs with the command `vagrant destroy -f`.

1. Shell into master node using the command `vagrant ssh kube-master`.
2. Check that all nodes have been correctly registered and are in the "Ready" status.
3. Find out the version of etcd running in the cluster.
4. Identify the endpoint URL for the etcd service, the location of the server certificate and the location of the CA certificate.
5. Create a snapshot of the etcd database. Store the backup in the file `/opt/etcd-backup.db`.
6. Restore the original state of the cluster from the backup file at `/opt/etcd-backup.db` to the directory `/var/lib/from-backup`.
7. Point etcd to the new directory containing the restored backup.

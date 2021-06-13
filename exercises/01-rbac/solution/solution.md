# Solution

## Creating the User

Set a user entry in `kubeconfig` for `johndoe`. Point to the CRT and key file.

```
$ kubectl config set-credentials johndoe --client-certificate=johndoe.crt --client-key=johndoe.key
User "johndoe" set.
```

Set a context entry in `kubeconfig` for `johndoe`.

```
$ kubectl config set-context johndoe-context --cluster=minikube --user=johndoe
Context "johndoe-context" created.
```

Set the `johndoe-context` context in the `kubeconfig` file. You can check the current context using `config current-context`.

```
$ kubectl config use-context johndoe-context
Switched to context "johndoe-context".
$ kubectl config current-context
johndoe-context
```

Creating a Pod in the current context won't work as the user `johndoe` does have the proper permissions.

```
$ kubectl run nginx --image=nginx --port=80
Error from server (Forbidden): pods is forbidden: User "johndoe" cannot create resource "pods" in API group "" in the namespace "default"
```

## Granting Access to the User

Change back to the original context.

```
$ kubectl config use-context minikube
Switched to context "minikube".
```

First, create a YAML file for the Role. The resource `pods` should be listed under `resources`. As verbs, set `get`, `watch`, and `list`. Store the following content in the file `role.yaml`.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: default
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "watch", "list"]
```

Create the Role by using the `create` command.

```
$ kubectl create -f role.yaml
role.rbac.authorization.k8s.io/pod-reader created
```

Next, create a YAML file for the RoleBinding. Ensure to list the user `johndoe` under `subjects`. Reference the Role named `pod-reader`. Store the following content in the file `role-binding.yaml`.

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: default
subjects:
- kind: User
  name: johndoe
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

Create the RoleBinding by using the `create` command.

```
$ kubectl create -f role-binding.yaml
rolebinding.rbac.authorization.k8s.io/read-pods created
```

Verify that both objects have been created.

```
$ kubectl get roles,rolebindings
NAME                                        CREATED AT
role.rbac.authorization.k8s.io/pod-reader   2020-10-24T19:40:30Z

NAME                                              ROLE              AGE
rolebinding.rbac.authorization.k8s.io/read-pods   Role/pod-reader   70s
```

## Verifying Permissions

Switch to the context `johndoe-context`.

```
$ kubectl config use-context johndoe-context
Switched to context "johndoe-context".
```

Creating a new Pod won't work as the user `johndoe` doesn't have the proper permissions.

```
$ kubectl run nginx --image=nginx --port=80
Error from server (Forbidden): pods is forbidden: User "johndoe" cannot create resource "pods" in API group "" in the namespace "default"
```

The `list` operation is allowed for the user `johndoe` and therefore can be used properly.

```
$ kubectl get pods
No resources found in default namespace.
```

You can check the permissions of the `johndoe` user from the default context. As you can see, the operations `list`, `get`, and `watch` are permitted, whereas the `delete` operation is forbidden.

```
$ kubectl config use-context minikube
Switched to context "minikube".
$ kubectl auth can-i list pods --as johndoe
yes
$ kubectl auth can-i get pods --as johndoe
yes
$ kubectl auth can-i watch pods --as johndoe
yes
$ kubectl auth can-i delete pods --as johndoe
no
```

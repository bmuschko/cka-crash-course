openssl genrsa -out johndoe.key 2048
openssl req -new -key johndoe.key -out johndoe.csr -subj "/CN=johndoe"
csr=$(cat johndoe.csr | base64 | tr -d "\n")

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: johndoe
spec:
  request: $csr
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 86400
  usages:
  - client auth
EOF

kubectl certificate approve johndoe
kubectl get csr johndoe -o jsonpath='{.status.certificate}'| base64 -d > johndoe.crt
kubectl config set-credentials johndoe --client-key=johndoe.key --client-certificate=johndoe.crt --embed-certs=true
kubectl config set-context johndoe --cluster=minikube --user=johndoe

#!/usr/bin/env bash

# Install etcdctl
ETCD_VERSION="v3.5.15"

ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" == "aarch64" ]; then
    ARCH="arm64"
elif [ "$ARCH" == "armv7l" ]; then
    ARCH="arm"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

wget https://github.com/etcd-io/etcd/releases/download/$ETCD_VERSION/etcd-$ETCD_VERSION-linux-$ARCH.tar.gz -O /tmp/etcd-$ETCD_VERSION-linux-$ARCH.tar.gz
tar xvf /tmp/etcd-$ETCD_VERSION-linux-$ARCH.tar.gz -C /tmp
sudo mv /tmp/etcd-$ETCD_VERSION-linux-$ARCH/etcd /tmp/etcd-$ETCD_VERSION-linux-$ARCH/etcdctl /tmp/etcd-$ETCD_VERSION-linux-$ARCH/etcdutl /usr/local/bin
#!/usr/bin/env bash

# Misconfigure kubelet configuration
sudo sed -i 's/clientCAFile: \/etc\/kubernetes\/pki\/ca.crt/clientCAFile: \/etc\/kubernetes\/pki\/non-existent-ca.crt/g' /var/lib/kubelet/config.yaml

# Restart kubelet to pick up new configuration
systemctl daemon-reload
systemctl restart kubelet
#!/bin/bash

set -e

echo "🔄 Cleaning old Cilium & Hubble resources..."

# Delete Cilium-specific resources
kubectl delete daemonset cilium -n kube-system --ignore-not-found
kubectl delete deployment cilium-operator -n kube-system --ignore-not-found
kubectl delete serviceaccount cilium cilium-operator -n kube-system --ignore-not-found
kubectl delete configmap cilium-config -n kube-system --ignore-not-found
kubectl delete clusterrole cilium cilium-operator --ignore-not-found
kubectl delete clusterrolebinding cilium cilium-operator --ignore-not-found
kubectl delete role cilium-config-agent -n kube-system --ignore-not-found
kubectl delete rolebinding cilium-config-agent -n kube-system --ignore-not-found

# Delete Hubble leftovers
kubectl delete deployment hubble-relay hubble-ui -n kube-system --ignore-not-found
kubectl delete service hubble-relay hubble-ui hubble-peer -n kube-system --ignore-not-found
kubectl delete secret hubble-ca-secret hubble-relay-client-certs hubble-server-certs -n kube-system --ignore-not-found
kubectl delete configmap hubble-relay-config hubble-ui-nginx -n kube-system --ignore-not-found
kubectl delete serviceaccount hubble-relay hubble-ui -n kube-system --ignore-not-found
kubectl delete clusterrole hubble-relay hubble-ui --ignore-not-found
kubectl delete clusterrolebinding hubble-relay hubble-ui --ignore-not-found

echo "✅ Cleaned legacy resources."

echo "⬇️ Installing Cilium CLI if not present..."
if ! command -v cilium >/dev/null 2>&1; then
  curl -L --remote-name https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz
  tar xzvf cilium-linux-amd64.tar.gz
  mv cilium /usr/local/bin/
  chmod +x /usr/local/bin/cilium
fi

echo "🚀 Installing Cilium 1.14.4..."
cilium install --version 1.14.4 --wait

echo "✅ Cilium installed successfully!"

echo "🔍 Verifying status..."
cilium status

echo "✅ Done!"

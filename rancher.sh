#!/bin/bash

set -e

# Configurable variables
RANCHER_NAMESPACE="cattle-system"
CERT_MANAGER_VERSION="v1.12.2"
RANCHER_VERSION="2.11.1"
RANCHER_HOSTNAME="rancher.local"  # You can change this or set up local DNS

# Step 0: Check cluster access
echo "🔍 Checking Kubernetes cluster access..."
if ! kubectl version --short > /dev/null 2>&1; then
  echo "❌ kubectl is not connected to a Kubernetes cluster. Please check your kubeconfig."
  exit 1
fi

# Step 1: Create Rancher namespace
echo "📦 Creating namespace: $RANCHER_NAMESPACE"
kubectl create namespace $RANCHER_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Step 2: Install cert-manager
echo "🔐 Installing cert-manager..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/${CERT_MANAGER_VERSION}/cert-manager.yaml

# Wait for cert-manager to be ready
echo "⏳ Waiting for cert-manager to become ready..."
kubectl rollout status deployment cert-manager -n cert-manager --timeout=120s
kubectl rollout status deployment cert-manager-webhook -n cert-manager --timeout=120s
kubectl rollout status deployment cert-manager-cainjector -n cert-manager --timeout=120s

# Step 3: Add Helm repo
echo "📥 Adding Rancher Helm repo..."
helm repo add rancher-latest https://releases.rancher.com/server-charts/latest
helm repo update

# Step 4: Install Rancher with NodePort
echo "🚀 Installing Rancher with NodePort..."
helm install rancher rancher-latest/rancher \
  --namespace $RANCHER_NAMESPACE \
  --set hostname=$RANCHER_HOSTNAME \
  --set replicas=1 \
  --set ingress.enabled=false \
  --set service.type=NodePort \
  --version $RANCHER_VERSION

# Step 5: Wait for Rancher deployment
echo "⏳ Waiting for Rancher pod to be ready..."
kubectl -n $RANCHER_NAMESPACE rollout status deploy/rancher --timeout=180s

# Step 6: Reset admin password
echo "🔐 Setting Rancher admin password..."
RANCHER_POD=$(kubectl -n $RANCHER_NAMESPACE get pods -l app=rancher -o jsonpath="{.items[0].metadata.name}")
NEW_PASSWORD="Admin@$(openssl rand -base64 6 | tr -dc A-Za-z0-9)"
kubectl -n $RANCHER_NAMESPACE exec -it "$RANCHER_POD" -- reset-password <<< "$NEW_PASSWORD"

# Step 7: Get NodePort and IP
NODE_PORT=$(kubectl -n $RANCHER_NAMESPACE get svc rancher -o jsonpath='{.spec.ports[0].nodePort}')
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[?(@.type=="ExternalIP")].address}')

echo
echo "✅ Rancher installed successfully!"
echo "🌐 Access URL: http://${NODE_IP}:${NODE_PORT}"
echo "🔑 Admin password: $NEW_PASSWORD"

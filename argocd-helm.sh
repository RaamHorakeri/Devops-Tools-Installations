#!/bin/bash

# Exit on error
set -e

# Check if server IP is passed
if [ -z "$1" ]; then
    echo "Usage: $0 <SERVER_IP>"
    exit 1
fi

SERVER_IP="$1"
NAMESPACE="argocd"
HELM_RELEASE_NAME="argocd"

# Step 1: Create ArgoCD Namespace
echo "🔹 Creating namespace: $NAMESPACE..."
kubectl create namespace $NAMESPACE || echo "Namespace already exists."

# Step 2: Add the ArgoCD Helm Repo
echo "🔹 Adding ArgoCD Helm repository..."
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Step 3: Install ArgoCD with Helm
echo "🔹 Installing ArgoCD using Helm..."
helm upgrade --install $HELM_RELEASE_NAME argo/argo-cd \
    --namespace $NAMESPACE \
    --set server.service.type=NodePort \
    --set server.service.nodePort=30080

# Step 4: Wait for ArgoCD pods to be ready
echo "🔹 Waiting for ArgoCD to be ready..."
kubectl wait --for=condition=ready pod -n $NAMESPACE --all --timeout=300s

# Step 5: Retrieve the ArgoCD Admin Password
echo "🔹 Retrieving the ArgoCD admin password..."
ADMIN_PASSWORD=$(kubectl -n $NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode || echo "Secret not found!")

# Check if password retrieval was successful
if [ -z "$ADMIN_PASSWORD" ] || [ "$ADMIN_PASSWORD" == "Secret not found!" ]; then
    echo "❌ Error: Unable to retrieve ArgoCD password. Please check if the secret exists."
    echo "Run the following command manually:"
    echo "kubectl -n $NAMESPACE get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode"
    exit 1
fi

echo "✅ ArgoCD installation completed!"
echo "🌐 Access ArgoCD UI at: http://$SERVER_IP:30080"
echo "🔑 Login using:"
echo "   Username: admin"
echo "   Password: $ADMIN_PASSWORD"

# Optional: Suggest deleting the initial secret
echo "🚨 Security Tip: After logging in, consider deleting the initial admin secret for security:"
echo "kubectl delete secret argocd-initial-admin-secret -n $NAMESPACE"

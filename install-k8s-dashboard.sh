#!/bin/bash

# Namespace and Release name
NAMESPACE="kubernetes-dashboard"
RELEASE_NAME="kubernetes-dashboard"

echo "🚀 Adding Kubernetes Dashboard Helm repo..."
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update

echo "🧹 Cleaning up old install if it exists..."
helm uninstall $RELEASE_NAME -n $NAMESPACE 2>/dev/null
kubectl delete ns $NAMESPACE --ignore-not-found

echo "📦 Installing Kubernetes Dashboard using Helm..."
helm upgrade --install $RELEASE_NAME kubernetes-dashboard/kubernetes-dashboard \
  --namespace $NAMESPACE \
  --create-namespace \
  --set service.type=NodePort \
  --set protocolHttp=true \
  --set service.nodePort=30557

echo "⏳ Waiting for dashboard pod to be ready..."
kubectl wait --namespace $NAMESPACE \
  --for=condition=ready pod \
  --selector="app.kubernetes.io/name=kubernetes-dashboard" \
  --timeout=120s

echo "👤 Creating admin ServiceAccount and ClusterRoleBinding..."
kubectl apply -f - <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: $NAMESPACE
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: $NAMESPACE
EOF

echo "🔑 Fetching access token..."
TOKEN=$(kubectl -n $NAMESPACE create token admin-user)

echo "🌐 Getting NodePort and public IP..."
NODE_PORT=$(kubectl -n $NAMESPACE get svc $RELEASE_NAME-kubernetes-dashboard -o jsonpath='{.spec.ports[0].nodePort}')
EXTERNAL_IP=$(curl -s ifconfig.me || curl -s https://api.ipify.org)

echo "✅ DONE!"
echo "=================================================="
echo "🔗 Dashboard URL: https://$EXTERNAL_IP:$NODE_PORT"
echo
echo "🔑 Login Token:"
echo "$TOKEN"
echo
echo "⚠️  Use HTTPS and click 'Advanced > Proceed anyway' if browser warns."
echo "=================================================="

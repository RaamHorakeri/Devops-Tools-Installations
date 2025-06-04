#!/bin/bash

# Exit on error
set -e

# Validate arguments
if [ "$#" -ne 2 ]; then
    echo "❌ Usage: $0 <DO_API_TOKEN> <CLUSTER_ID>"
    exit 1
fi

DO_API_TOKEN="$1"
CLUSTER_ID="$2"

echo "🔐 Authenticating with DigitalOcean..."
doctl auth init -t "$DO_API_TOKEN"

echo "📥 Saving Kubernetes cluster kubeconfig for cluster ID: $CLUSTER_ID..."
doctl kubernetes cluster kubeconfig save "$CLUSTER_ID"

echo "📋 Available contexts:"
kubectl config get-contexts

echo "✅ Connected to cluster: $(kubectl config current-context)"

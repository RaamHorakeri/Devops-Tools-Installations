#!/bin/bash

# === CONFIGURATION ===
DOCKER_REGISTRY="registry.digitalocean.com"
REGISTRY_NAMESPACE="eskeon"
DEPLOYMENT_NAME="public-web"
NAMESPACE="eskeon"
SECRET_NAME="eskeon-cont-reg-access"
DO_API_TOKEN="DO token"

# === STEP 1: Create the image pull secret ===
echo "Creating image pull secret..."
kubectl create secret docker-registry $SECRET_NAME \
  --docker-server=$DOCKER_REGISTRY \
  --docker-username=doctl \
  --docker-password=$DO_API_TOKEN \
  --namespace $NAMESPACE \
  --dry-run=client -o yaml | kubectl apply -f -

# === STEP 2: Patch the deployment with the secret ===
echo "Patching deployment to use image pull secret..."
kubectl patch deployment $DEPLOYMENT_NAME -n $NAMESPACE --patch "{
  \"spec\": {
    \"template\": {
      \"spec\": {
        \"imagePullSecrets\": [
          {
            \"name\": \"$SECRET_NAME\"
          }
        ]
      }
    }
  }
}"

# === STEP 3: Restart deployment ===
echo "Restarting deployment to apply changes..."
kubectl rollout restart deployment $DEPLOYMENT_NAME -n $NAMESPACE

echo "✅ Image pull secret configured and deployment restarted."

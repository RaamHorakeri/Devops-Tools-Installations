#!/bin/bash

set -e

HELM_VERSION="v3.14.4"
ARCH="amd64"

echo "🚀 Installing Helm ${HELM_VERSION}..."

# Install required packages
sudo apt update -y
sudo apt install -y curl tar

# Download Helm
curl -fsSL https://get.helm.sh/helm-${HELM_VERSION}-linux-${ARCH}.tar.gz -o helm.tar.gz

# Extract
tar -xzf helm.tar.gz

# Move binary
sudo mv linux-${ARCH}/helm /usr/local/bin/helm

# Set permissions
sudo chmod +x /usr/local/bin/helm

# Cleanup
rm -rf linux-${ARCH} helm.tar.gz

# Verify
echo "✅ Helm installed successfully"
helm version

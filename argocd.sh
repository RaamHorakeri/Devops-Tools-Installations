#!/bin/bash

set -e

# Fetch the latest stable version of Argo CD
VERSION=$(curl -L -s https://raw.githubusercontent.com/argoproj/argo-cd/stable/VERSION)

# Download the Argo CD binary
curl -sSL -o argocd-linux-amd64 "https://github.com/argoproj/argo-cd/releases/download/v$VERSION/argocd-linux-amd64"

# Install Argo CD binary
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd

# Remove the downloaded file
rm -f argocd-linux-amd64

# Print the installed version
argocd version --client

echo "Argo CD CLI installed successfully!"

#!/bin/bash
# Download the latest stable release of kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Download the checksum for verification
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"

# Verify the downloaded binary with the checksum
echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check

# Install kubectl to /usr/local/bin with root ownership and appropriate permissions
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Display the installed kubectl version
kubectl version --client

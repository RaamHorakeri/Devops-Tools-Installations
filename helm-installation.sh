#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Installing Helm..."

# Add Helm GPG key
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null

# Install required package
sudo apt-get install apt-transport-https --yes

# Add Helm repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# Update package list
sudo apt-get update

# Install Helm
sudo apt-get install helm -y

# Verify installation
helm version

echo "Helm installation completed successfully!"

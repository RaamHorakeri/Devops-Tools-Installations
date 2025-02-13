#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Installing Minikube..."

# Download the latest Minikube binary
curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64

# Install Minikube
sudo install minikube-linux-amd64 /usr/local/bin/minikube
rm minikube-linux-amd64

echo "Minikube installed successfully."

# Start Minikube
echo "Starting Minikube..."
minikube start

# Check if Minikube started successfully
if [ $? -eq 0 ]; then
    echo "Minikube started successfully."
else
    echo "Failed to start Minikube. Check the logs for details."
    exit 1
fi

# Configure kubectl alias for convenience
echo "Setting up kubectl alias..."
echo 'alias kubectl="minikube kubectl --"' >> ~/.bashrc
source ~/.bashrc

# Verify Minikube cluster status
echo "Checking Minikube cluster status..."
kubectl get po -A

echo "Minikube installation and setup completed successfully."

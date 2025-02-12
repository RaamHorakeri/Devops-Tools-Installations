#!/bin/bash

# Step 1: Install MicroK8s
echo "Installing MicroK8s..."
sudo snap install microk8s --classic

# Wait for MicroK8s to start
echo "Waiting for MicroK8s to be ready..."
sudo microk8s status --wait-ready

# Add current user to MicroK8s group to avoid using sudo (requires re-login)
sudo usermod -aG microk8s $USER
sudo chown -R $USER ~/.kube

# Step 2: Check Default Kubernetes Objects
echo "Checking default Kubernetes objects..."
sudo microk8s kubectl get all -n kube-system

# Set up alias for kubectl to avoid using microk8s prefix
echo "Setting up kubectl alias..."
echo "alias kubectl='sudo microk8s kubectl'" >> ~/.bashrc
source ~/.bashrc

# Configure kubectl to use MicroK8s
echo "Configuring kubectl..."
mkdir -p ~/.kube
sudo microk8s kubectl config view --raw > ~/.kube/config

# Step 3: Enable MicroK8s Addons
echo "Enabling MicroK8s addons..."
sudo microk8s enable dns
sudo microk8s enable ingress

# Verify installation
echo "Verifying MicroK8s setup..."
kubectl get nodes
kubectl get pods -A

echo "MicroK8s setup completed successfully!"

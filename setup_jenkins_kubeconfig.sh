#!/bin/bash

set -e  # Exit on error

echo "🔹 Checking if Jenkins user exists..."
if id "jenkins" &>/dev/null; then
    echo "✅ Jenkins user found."
else
    echo "❌ Jenkins user not found! Make sure Jenkins is installed."
    exit 1
fi

echo "🔹 Creating .kube directory for Jenkins..."
sudo mkdir -p /var/lib/jenkins/.kube

echo "🔹 Copying Kubernetes config to Jenkins home directory..."
sudo cp ~/.kube/config /var/lib/jenkins/.kube/config
sudo chown jenkins:jenkins /var/lib/jenkins/.kube/config
sudo chmod 600 /var/lib/jenkins/.kube/config

echo "✅ kubeconfig successfully copied!"

echo "🔹 Restarting Jenkins to apply changes..."
sudo systemctl restart jenkins

echo "✅ Jenkins is now configured to access Kubernetes! 🚀"

#!/bin/bash

# Update package index
sudo apt-get update -y

# Install prerequisite packages
sudo apt-get install -y ca-certificates curl

# Create directory for Docker's keyring
sudo install -m 0755 -d /etc/apt/keyrings

# Download Docker's official GPG key
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Set up Docker's APT repository
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update package index again after adding Docker's repository
sudo apt-get update -y

# Install Docker packages without prompt
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify Docker installation
docker -v

# Set permissions for Docker socket
sudo chmod 777 /var/run/docker.sock

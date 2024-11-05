#!/bin/bash

# Update package index
sudo apt-get update -y

# Install Docker Compose plugin without prompt
sudo apt-get install -y docker-compose-plugin

# Verify Docker Compose installation
docker compose version

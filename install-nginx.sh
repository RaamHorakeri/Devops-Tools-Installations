#!/bin/bash

# Exit on error
set -e

echo "-------------------------------------"
echo "     NGINX INSTALLATION STARTED      "
echo "-------------------------------------"

# Update package list
echo "[1/4] Updating system packages..."
sudo apt update -y

# Install nginx
echo "[2/4] Installing NGINX..."
sudo apt install nginx -y

# Enable NGINX to start on boot
echo "[3/4] Enabling NGINX service..."
sudo systemctl enable nginx

# Start NGINX service
echo "[4/4] Starting NGINX service..."
sudo systemctl start nginx

echo "-------------------------------------"
echo " NGINX INSTALLED & RUNNING SUCCESSFULLY "
echo "-------------------------------------"

# Check status
sudo systemctl status nginx --no-pager

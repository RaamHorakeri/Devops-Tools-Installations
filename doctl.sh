#!/bin/bash
# Define the version of doctl to install
DOCTL_VERSION="1.115.0"

# Download the specified version of doctl
wget "https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz" -O "doctl-${DOCTL_VERSION}-linux-amd64.tar.gz"

# Extract the downloaded tar.gz file
tar xf "doctl-${DOCTL_VERSION}-linux-amd64.tar.gz"

# Move the doctl binary to /usr/local/bin with appropriate permissions
sudo mv doctl /usr/local/bin

# Confirm the installation by displaying the doctl version
doctl version

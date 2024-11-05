#!/bin/bash

# Update package index
sudo apt update -y

# Install fontconfig and OpenJDK 17 without prompts
sudo apt install -y fontconfig openjdk-17-jre

# Verify Java installation
java -version

# Download Jenkins GPG key
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key

# Add Jenkins repository to sources list
echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/" | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

# Update package index after adding Jenkins repository
sudo apt-get update -y

# Install Jenkins without prompts
sudo apt-get install -y jenkins

# Display initial Jenkins admin password
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

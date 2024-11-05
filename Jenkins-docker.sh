#!/bin/bash

# Pull the latest Jenkins LTS Docker image
docker pull jenkins/jenkins:lts

# Run Jenkins container
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts

# Display initial Jenkins admin password
echo "Waiting for Jenkins to start..."
sleep 20  # Wait a moment for Jenkins to initialize

echo "Initial Jenkins Admin Password:"
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword

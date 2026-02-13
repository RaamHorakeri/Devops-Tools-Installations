#!/bin/bash

set -e

JENKINS_IMAGE="jenkins/jenkins:latest"
CONTAINER_NAME="jenkins"
VOLUME_NAME="jenkins_home"

echo "Stopping existing Jenkins container (if any)..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

echo "Pulling latest Jenkins (NON-LTS / weekly)..."
docker pull $JENKINS_IMAGE

echo "Starting Jenkins with latest version..."
docker run -d \
  --name $CONTAINER_NAME \
  -p 8080:8080 \
  -p 50000:50000 \
  -v $VOLUME_NAME:/var/jenkins_home \
  --restart unless-stopped \
  $JENKINS_IMAGE

echo "Waiting for Jenkins to start..."
sleep 30

echo "Initial Jenkins Admin Password (only first time):"
docker exec $CONTAINER_NAME cat /var/jenkins_home/secrets/initialAdminPassword 2>/dev/null || \
echo "Jenkins already initialized."

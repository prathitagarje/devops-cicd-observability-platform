#!/bin/bash
set -euxo pipefail

echo " Starting setup for Basic Webapp..."

# Variables
IMAGE_NAME="prathitagarje/basic-webapp"
CONTAINER_NAME="basic-webapp"

# Check prerequisites
command -v docker >/dev/null || { echo "Docker not installed"; exit 1; }
command -v git >/dev/null || { echo "Git not installed"; exit 1; }

echo " Prerequisites check passed"

# Build Docker image
echo " Building Docker image..."
docker build -t $IMAGE_NAME:latest .

# Stop existing container if running
echo " Stopping old container..."
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Run container
echo " Running container..."
docker run -d \
  --name $CONTAINER_NAME \
  -p 3000:3000 \
  --restart always \
  $IMAGE_NAME:latest

# Health check
echo " Checking application health..."
for i in {1..10}; do
  if curl -s http://localhost:3000/health; then
    echo " Application is running!"
    exit 0
  fi
  sleep 3
done

echo " Application failed to start"
exit 1
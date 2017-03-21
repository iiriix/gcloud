#!/bin/sh
#
# Sample script to be run inside the container

# Exit on any error
set -e

# Source code is mounted as a volume in /code
cd /code

# Git commit hash, if it's git repo
COMMIT_ID=$(git rev-parse --short HEAD || true)

# Docker image tag
IMAGE_TAG=${COMMIT_ID:-latest}

# Docker image URL
IMAGE_URL="gcr.io/${CLOUDSDK_PROJECT_NAME}/sample-nginx"

# Build your docker image
docker build -t ${IMAGE_URL}:${IMAGE_TAG} .

# Push to Google Cloud Docker Registry
gcloud docker -- push ${IMAGE_URL}:${IMAGE_TAG}

# Set the image tag and apply the Kubernetes deployment files
FILENAME=$(grep -rl "image:.*" ./k8s/)
for i in ${FILENAME}; do
  sed -i -e "s#\(image: \).*:.*#\1${IMAGE_URL}:${IMAGE_TAG}#g" ${i}
done
kubectl apply -f ./k8s/

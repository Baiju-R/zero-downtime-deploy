#!/usr/bin/env bash
set -e

IMAGE_NAME="b41ju/zero-downtime-app"
TAG="$1"

if [ -z "$TAG" ]; then
  echo "Usage: ./deploy.sh <tag>"
  exit 1
fi

echo "==> Pulling image ${IMAGE_NAME}:${TAG}..."
docker pull "${IMAGE_NAME}:${TAG}"

echo "==> Stopping old container (if any)..."
docker stop zd-app || true
docker rm zd-app || true

echo "==> Starting new container..."
docker run -d \
  --name zd-app \
  -p 3000:3000 \
  -e APP_VERSION="${TAG}" \
  "${IMAGE_NAME}:${TAG}"

echo "==> Waiting for app to start..."
sleep 5

echo "==> Checking health via Nginx..."
if curl -f http://localhost/health >/dev/null 2>&1; then
  echo "✅ Deployment successful. Running version: ${TAG}"
else
  echo "❌ Health check failed! Rolling back (stopping new container)..."
  docker logs zd-app || true
  docker stop zd-app || true
  docker rm zd-app || true
  exit 1
fi

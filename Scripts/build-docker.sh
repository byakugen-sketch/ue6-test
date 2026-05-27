#!/bin/bash
# Builds the Docker image from the packaged server
# Usage: ./Scripts/build-docker.sh [image-tag]
# Requires: ./Scripts/build-server.sh to have run first

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
IMAGE_TAG="${1:-latest}"
IMAGE_NAME="uzumaki420/ue5-gameserver:$IMAGE_TAG"

if [ ! -d "$PROJECT_ROOT/Output/LinuxServer" ]; then
  echo "Error: No staged server found. Run build-server.sh first."
  exit 1
fi

echo "Copying staged server to Docker build context..."
cp -r "$PROJECT_ROOT/Output/LinuxServer" "$PROJECT_ROOT/docker/LinuxServer"

echo "Building Docker image: $IMAGE_NAME"
docker buildx build \
  --platform linux/amd64 \
  --tag "$IMAGE_NAME" \
  --load \
  "$PROJECT_ROOT/docker/"

echo "Cleaning up build context..."
rm -rf "$PROJECT_ROOT/docker/LinuxServer"

echo "Image built: $IMAGE_NAME"

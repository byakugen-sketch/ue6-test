#!/bin/bash
# Builds the UE5 dedicated server for Linux using Epic's official container
# Usage: ./Scripts/build-server.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR="$PROJECT_ROOT/Output"
UE_IMAGE="ghcr.io/epicgames/unreal-engine:dev-slim-5.7"

echo "Building dedicated server using Epic container: $UE_IMAGE"

mkdir -p "$OUTPUT_DIR"

docker run --rm \
  --platform linux/amd64 \
  -v "$PROJECT_ROOT/ue6test:/project" \
  -v "$OUTPUT_DIR:/output" \
  "$UE_IMAGE" \
  /bin/bash -c "
    /home/ue4/UnrealEngine/Engine/Build/BatchFiles/RunUAT.sh BuildCookRun \
      -project=/project/ue6test.uproject \
      -noP4 \
      -platform=Linux \
      -serverconfig=Development \
      -cook \
      -build \
      -stage \
      -pak \
      -archive \
      -archivedirectory=/output \
      -server \
      -noclient \
      -targetplatform=Linux \
      -servertarget=ue6testServer \
      -utf8output \
      -unattended
  "

echo "Build complete. Output at: $OUTPUT_DIR/LinuxServer"

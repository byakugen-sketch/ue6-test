#!/bin/bash
# Packages the UE5 dedicated server for Linux from Mac
# Usage: ./Scripts/build-server.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
UE_ROOT="/Users/Shared/Epic Games/UE_5.5"
OUTPUT_DIR="$PROJECT_ROOT/Output"

# Find the .uproject file
UPROJECT=$(find "$PROJECT_ROOT" -maxdepth 1 -name "*.uproject" | head -1)
if [ -z "$UPROJECT" ]; then
  echo "Error: No .uproject file found in $PROJECT_ROOT"
  exit 1
fi

PROJECT_NAME=$(basename "$UPROJECT" .uproject)
echo "Building server for project: $PROJECT_NAME"

"$UE_ROOT/Engine/Build/BatchFiles/RunUAT.sh" BuildCookRun \
  -project="$UPROJECT" \
  -noP4 \
  -platform=Linux \
  -serverconfig=Development \
  -cook \
  -build \
  -stage \
  -pak \
  -archive \
  -archivedirectory="$OUTPUT_DIR" \
  -server \
  -noclient \
  -targetplatform=Linux \
  -servertarget="${PROJECT_NAME}Server" \
  -utf8output \
  -unattended

echo "Build complete. Output at: $OUTPUT_DIR/LinuxServer"

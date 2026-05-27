#!/bin/bash
# Packages the UE5 dedicated server for Linux from Mac
# Usage: ./Scripts/build-server.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
UE_ROOT="/Users/Shared/Epic Games/UE_5.7"
UPROJECT="$PROJECT_ROOT/ue6test/ue6test.uproject"
OUTPUT_DIR="$PROJECT_ROOT/Output"

echo "Building dedicated server for ue6test..."

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
  -servertarget=ue6testServer \
  -utf8output \
  -unattended

echo "Build complete. Output at: $OUTPUT_DIR/LinuxServer"

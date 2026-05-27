#!/bin/bash
# Sets up the Linux cross-compilation toolchain for UE5 on Mac
# Run this once before building for the first time
# Download the toolchain from:
# https://dev.epicgames.com/documentation/en-us/unreal-engine/linux-development-requirements-for-unreal-engine

set -e

TOOLCHAIN_DIR="$HOME/UnrealToolchain"
ZSHRC="$HOME/.zshrc"

if [ ! -f "$1" ]; then
  echo "Usage: ./Scripts/setup-toolchain.sh /path/to/UnrealToolchain-5.5-v22-*.tar.gz"
  exit 1
fi

echo "Installing toolchain to $TOOLCHAIN_DIR..."
mkdir -p "$TOOLCHAIN_DIR"
tar -xzf "$1" -C "$TOOLCHAIN_DIR"

if ! grep -q "LINUX_MULTIARCH_ROOT" "$ZSHRC"; then
  echo "export LINUX_MULTIARCH_ROOT=$TOOLCHAIN_DIR/x86_64-unknown-linux-gnu" >> "$ZSHRC"
  echo "Added LINUX_MULTIARCH_ROOT to $ZSHRC"
fi

echo "Toolchain installed. Run: source ~/.zshrc"

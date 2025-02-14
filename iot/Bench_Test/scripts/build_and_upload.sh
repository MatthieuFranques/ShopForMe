#!/bin/bash
set -e

# Arguments
TARGET_PATH=$1
SERIAL_PORT=$2
BUILD_DIR=$3
FQBN="esp32:esp32:esp32"

# Compilation
echo "[INFO] Compiling $TARGET_PATH..."
arduino-cli compile --fqbn $FQBN --output-dir $BUILD_DIR $TARGET_PATH

# Vérifier si le firmware a été généré
if [ ! -f "$BUILD_DIR/main.ino.bin" ]; then
  echo "[ERROR] Compilation failed. No firmware generated."
  exit 1
fi

# Téléversement
echo "[INFO] Uploading firmware to $SERIAL_PORT..."
python3 -m esptool --chip esp32 --port $SERIAL_PORT --baud 921600 write_flash -z 0x1000 "$BUILD_DIR/main.ino.bin"

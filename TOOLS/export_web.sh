#!/bin/bash

cd /Users/nikita/Desktop/BOB

GODOT="/Applications/godot.app/Contents/MacOS/godot"
EXPORT_DIR="/Users/nikita/Desktop/BOB/export"

mkdir -p "$EXPORT_DIR"

echo "=== Exporting Web (Release) ==="
$GODOT --headless --export-release "Web" "$EXPORT_DIR/index.html"

echo ""
echo "=== Exporting Windows Desktop (Release) ==="
$GODOT --headless --export-release "Windows Desktop" "$EXPORT_DIR/BOB.exe"

echo ""
echo "=== Exporting macOS (Release) ==="
$GODOT --headless --export-release "macOS" "$EXPORT_DIR/BOB.zip"

echo ""
echo "=== Export complete ==="
echo "Web: $EXPORT_DIR/index.html"
echo "Windows: $EXPORT_DIR/BOB.exe"
echo "macOS: $EXPORT_DIR/BOB.zip"

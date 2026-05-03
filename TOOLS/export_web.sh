#!/bin/bash

cd /Users/nikita/Desktop/BOB

OUTPUT_DIR="/Users/nikita/Desktop/BOB/export/web"

mkdir -p "$OUTPUT_DIR"

/Applications/godot.app/Contents/MacOS/godot --headless --export-release "Web" "$OUTPUT_DIR/index.html"

echo "Exported to $OUTPUT_DIR"

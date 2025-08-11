#!/bin/bash
echo "This will install all config files in config-files"
echo "it wil place them in ~/.config"
read -p "Press Enter to install, CTRL+c to cancel"


TARGET_DIR="$HOME/.config"

# Get the script's directory (so config-files is always relative to it)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/Config-Files"

# Ensure source exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Source directory '$SOURCE_DIR' does not exist."
  exit 1
fi

echo "Copying configs from $SOURCE_DIR to $TARGET_DIR..."

# Copy each subdirectory inside config-files
for dir in $SOURCE_DIR/*; do
  if [ -d "$dir" ]; then
    dirname=$(basename "$dir")
    mkdir -p "$TARGET_DIR/$dirname"
    cp -r "$dir/"* "$TARGET_DIR/$dirname/"
    echo "Copied: $dirname"
  fi
done

echo "Done."


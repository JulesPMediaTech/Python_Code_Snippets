#!/bin/bash

# === CONFIGURATION ===
APP_NAME="MyApp"
VOLUME_NAME="MyApp Installer"
STAGING_DIR="$HOME/dmg-staging"
APP_PATH="/path/to/MyApp.app"  # Change this to your .app path
FINAL_DMG="$HOME/Desktop/$APP_NAME.dmg"
TEMP_DMG="$HOME/Desktop/$APP_NAME-temp.dmg"
BACKGROUND_IMAGE="/path/to/background.png"  # Optional: leave blank if none

# === PREPARE STAGING FOLDER ===
echo "Preparing staging folder..."
rm -rf "$STAGING_DIR"
mkdir -p "$STAGING_DIR/$APP_NAME"
cp -R "$APP_PATH" "$STAGING_DIR/"

if [ -f "$BACKGROUND_IMAGE" ]; then
  mkdir "$STAGING_DIR/.background"
  cp "$BACKGROUND_IMAGE" "$STAGING_DIR/.background/"
fi

# === CREATE TEMP READ/WRITE DISK IMAGE ===
echo "Creating temporary read/write disk image..."
hdiutil create -srcfolder "$STAGING_DIR" \
  -volname "$VOLUME_NAME" \
  -fs HFS+ \
  -format UDRW \
  "$TEMP_DMG"

# === MOUNT DISK IMAGE ===
echo "Mounting disk image..."
MOUNT_DIR=$(hdiutil attach "$TEMP_DMG" | grep -o '/Volumes/.*')
echo "Mounted at: $MOUNT_DIR"

# === PAUSE FOR CUSTOMIZATION ===
echo "PLEASE DO THE FOLLOWING:"
echo "1. Open Finder to '$MOUNT_DIR'"
echo "2. Arrange icons, set background (View > Show View Options)"
echo "   (N.B. Always use Icon View and add any desired background images from inside the mounted DMG using Finder's view options.)" 
echo "3. Close the window to save .DS_Store"
read -p "Press [Enter] once done customizing in Finder..."

# === SET PERMISSIONS ===
echo "Setting permissions..."
chmod -Rf go-w "$MOUNT_DIR"

# === UNMOUNT IMAGE ===
echo "Unmounting..."
hdiutil detach "$MOUNT_DIR"

# === CONVERT TO COMPRESSED READ-ONLY DMG ===
echo "Creating final DMG..."
hdiutil convert "$TEMP_DMG" -format UDZO -imagekey zlib-level=9 -o "$FINAL_DMG"

# === CLEANUP ===
rm "$TEMP_DMG"
rm -rf "$STAGING_DIR"

echo "DMG created successfully at: $FINAL_DMG"

#!/bin/bash

# Exit on error
set -e

# Check if AppImage path is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <path-to-appimage> [app-name]"
    echo "Example: $0 ~/Downloads/cursor-0.44.9x86_64.AppImage Cursor"
    exit 1
fi

APPIMAGE_PATH="$1"
# Extract filename without extension for default naming
FILENAME=$(basename "$APPIMAGE_PATH")
FILENAME_NOEXT="${FILENAME%.*}"

# If app name is provided as second argument, use it; otherwise use filename
APP_DISPLAY_NAME="${2:-${FILENAME_NOEXT}}"
# Convert display name to lowercase, replace spaces with hyphens for package name
PACKAGE_NAME=$(echo "$APP_DISPLAY_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
VERSION="1.0.0"
ARCH="amd64"
PACKAGE_DIR="${PACKAGE_NAME}-package"

echo "Packaging $APPIMAGE_PATH as $APP_DISPLAY_NAME ($PACKAGE_NAME)..."

# Create base directory structure
echo "Creating directory structure..."
mkdir -p "${PACKAGE_DIR}/DEBIAN"
mkdir -p "${PACKAGE_DIR}/opt/${PACKAGE_NAME}"
mkdir -p "${PACKAGE_DIR}/usr/share/applications"
mkdir -p "${PACKAGE_DIR}/usr/share/icons/hicolor/256x256/apps"

# Create DEBIAN/control file
echo "Creating control file..."
cat > "${PACKAGE_DIR}/DEBIAN/control" << EOF
Package: ${PACKAGE_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Essential: no
Depends: libc6 (>= 2.31)
Maintainer: Package Maintainer <maintainer@example.com>
Description: ${APP_DISPLAY_NAME} packaged as AppImage
 This is a Debian package of ${APP_DISPLAY_NAME} AppImage.
EOF

# Create post-installation script
echo "Creating post-installation script..."
cat > "${PACKAGE_DIR}/DEBIAN/postinst" << EOF
#!/bin/sh
set -e

# Update desktop database and icon cache
update-desktop-database -q
gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor

exit 0
EOF

# Make postinst executable
chmod 755 "${PACKAGE_DIR}/DEBIAN/postinst"

# Copy the AppImage
echo "Copying AppImage..."
cp "$APPIMAGE_PATH" "${PACKAGE_DIR}/opt/${PACKAGE_NAME}/${PACKAGE_NAME}.AppImage"
chmod +x "${PACKAGE_DIR}/opt/${PACKAGE_NAME}/${PACKAGE_NAME}.AppImage"

# Create .desktop file
echo "Creating .desktop file..."
cat > "${PACKAGE_DIR}/usr/share/applications/${PACKAGE_NAME}.desktop" << EOF
[Desktop Entry]
Name=${APP_DISPLAY_NAME}
Comment=${APP_DISPLAY_NAME} Application
Exec=/opt/${PACKAGE_NAME}/${PACKAGE_NAME}.AppImage
Icon=${PACKAGE_NAME}
Type=Application
Categories=Utility;Application;
Terminal=false
EOF

# Create a simple icon (blue square as placeholder)
echo "Creating placeholder icon..."
convert -size 256x256 xc:blue "${PACKAGE_DIR}/usr/share/icons/hicolor/256x256/apps/${PACKAGE_NAME}.png"

# Set correct permissions
echo "Setting permissions..."
find "${PACKAGE_DIR}" -type d -exec chmod 755 {} \;
find "${PACKAGE_DIR}" -type f -exec chmod 644 {} \;
chmod 755 "${PACKAGE_DIR}/DEBIAN/postinst"
chmod 755 "${PACKAGE_DIR}/opt/${PACKAGE_NAME}/${PACKAGE_NAME}.AppImage"

# Build the package
echo "Building Debian package..."
dpkg-deb --build "${PACKAGE_DIR}"

# Rename the package to the correct format
mv "${PACKAGE_DIR}.deb" "${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

echo "Done! Your package has been created as ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
echo
echo "To install the package:"
echo "sudo dpkg -i ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
echo
echo "To verify the package contents:"
echo "dpkg -c ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
echo
echo "To verify the package metadata:"
echo "dpkg -I ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

# Cleanup
echo "Cleaning up build directory..."
rm -rf "${PACKAGE_DIR}" 
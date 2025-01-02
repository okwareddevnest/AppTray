#!/bin/bash

# Exit on error
set -e

# Package details
PACKAGE_NAME="apptray"
VERSION="1.1.0"
ARCH="all"
PACKAGE_DIR="${PACKAGE_NAME}-${VERSION}"

# Create directory structure
echo "Creating directory structure..."
mkdir -p "${PACKAGE_DIR}/DEBIAN"
mkdir -p "${PACKAGE_DIR}/usr/bin"
mkdir -p "${PACKAGE_DIR}/usr/lib/${PACKAGE_NAME}"
mkdir -p "${PACKAGE_DIR}/usr/share/applications"
mkdir -p "${PACKAGE_DIR}/usr/share/icons/hicolor/256x256/apps"
mkdir -p "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}"

# Create control file
echo "Creating control file..."
cat > "${PACKAGE_DIR}/DEBIAN/control" << EOF
Package: ${PACKAGE_NAME}
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: ${ARCH}
Depends: bash, zenity, imagemagick, file
Recommends: desktop-file-utils
Maintainer: Dedan Okware <softengdedan@gmail.com>
Homepage: https://github.com/okwareddevnest/apptray
Description: Convert AppImage files to Debian packages
 AppTray is a tool that helps you convert AppImage files
 into proper Debian packages with desktop integration.
 .
 Features:
  * Command-line interface
  * Desktop integration
  * Simple to use
  * Created by Dedan Okware
EOF

# Create post-installation script
echo "Creating post-installation script..."
cat > "${PACKAGE_DIR}/DEBIAN/postinst" << EOF
#!/bin/sh
set -e
update-desktop-database -q
gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor
exit 0
EOF
chmod 755 "${PACKAGE_DIR}/DEBIAN/postinst"

# Copy main script
cp apptray "${PACKAGE_DIR}/usr/bin/"
chmod 755 "${PACKAGE_DIR}/usr/bin/apptray"

# Copy packaging script
cp package_appimage.sh "${PACKAGE_DIR}/usr/lib/${PACKAGE_NAME}/"
chmod 755 "${PACKAGE_DIR}/usr/lib/${PACKAGE_NAME}/package_appimage.sh"

# Copy desktop file
cp apptray.desktop "${PACKAGE_DIR}/usr/share/applications/"

# Create icon (blue gear as placeholder)
convert -size 256x256 xc:none -fill blue -draw "circle 128,128 128,64" \
        -draw "circle 128,128 64,128" "${PACKAGE_DIR}/usr/share/icons/hicolor/256x256/apps/${PACKAGE_NAME}.png"

# Create documentation
cat > "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}/README.md" << EOF
# AppTray

Convert AppImage files to Debian packages with desktop integration.

Created by Dedan Okware ([@okwareddevnest](https://github.com/okwareddevnest))

## Usage

### Command Line
\`\`\`bash
apptray /path/to/your/app.AppImage "App Name"
\`\`\`

### GUI
Launch from your application menu or run:
\`\`\`bash
apptray --gui
\`\`\`

For more information, visit: https://github.com/okwareddevnest/apptray

## Support
For issues and feature requests, please visit the GitHub repository.

## License
This project is licensed under the MIT License.
Copyright (c) 2025 Dedan Okware <softengdedan@gmail.com>
EOF

# Copy license file
cp LICENSE "${PACKAGE_DIR}/usr/share/doc/${PACKAGE_NAME}/"

# Set permissions
find "${PACKAGE_DIR}" -type d -exec chmod 755 {} \;
find "${PACKAGE_DIR}" -type f -exec chmod 644 {} \;
chmod 755 "${PACKAGE_DIR}/DEBIAN/postinst"
chmod 755 "${PACKAGE_DIR}/usr/bin/apptray"
chmod 755 "${PACKAGE_DIR}/usr/lib/${PACKAGE_NAME}/package_appimage.sh"

# Build package
echo "Building Debian package..."
dpkg-deb --build "${PACKAGE_DIR}"

# Rename to proper format
mv "${PACKAGE_DIR}.deb" "${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"

echo "Done! Package created as ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
echo
echo "To install:"
echo "sudo dpkg -i ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
echo "sudo apt-get install -f  # Install any missing dependencies" 
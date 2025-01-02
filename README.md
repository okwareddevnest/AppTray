# AppTray

Convert AppImage files into Debian packages with desktop integration.

## Features

- Convert any AppImage to a proper Debian package
- Automatic desktop integration (menu entry, icon)
- Command-line interface
- GUI interface (coming soon)
- Preserves AppImage functionality
- Easy to use

## Installation

### From Package (Recommended)

```bash
# Download the latest .deb package
sudo dpkg -i apptray_1.0.0_all.deb
sudo apt-get install -f  # Install dependencies
```

### From Source

```bash
# Clone the repository
git clone https://github.com/okwareddevnest/apptray.git
cd apptray

# Build the package
./build_apptray_deb.sh

# Install
sudo dpkg -i apptray_1.0.0_all.deb
sudo apt-get install -f
```

## Usage

### Command Line

```bash
# Show help
apptray --help

# Convert an AppImage
apptray /path/to/your/app.AppImage "App Name"

# Show version
apptray --version
```

### GUI Interface

Launch from your application menu or run:
```bash
apptray --gui
```

## Project Structure

```
.
├── build_apptray_deb.sh  # Main build script
├── package_appimage.sh   # AppImage packaging script
├── apptray              # Main executable
├── apptray.desktop      # Desktop entry
├── LICENSE              # MIT License
└── README.md            # This file
```

## Dependencies

- bash
- zenity (for GUI)
- imagemagick
- file
- desktop-file-utils

## Development

Want to contribute? Great! Please:

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

### Versioning

We use Semantic Versioning (SemVer) for version management. Version numbers are automatically updated based on commit messages:

- `fix: message` - Patch version update (bug fixes)
- `feat: message` - Minor version update (new features)
- `BREAKING CHANGE: message` - Major version update (breaking changes)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

- **Dedan Okware** - [GitHub](https://github.com/okwareddevnest)
- Email: softengdedan@gmail.com

## Support

For support, issues, or feature requests, please [create an issue](https://github.com/okwareddevnest/apptray/issues) on GitHub. 
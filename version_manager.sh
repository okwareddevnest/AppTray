#!/bin/bash

VERSION_FILE="version.txt"

# Function to read current version
get_version() {
    if [ -f "$VERSION_FILE" ]; then
        cat "$VERSION_FILE"
    else
        echo "1.0.0"
    fi
}

# Function to increment version
# Usage: increment_version major|minor|patch
increment_version() {
    local current_version=$(get_version)
    local major minor patch
    
    # Parse current version
    IFS='.' read -r major minor patch <<< "$current_version"
    
    # Increment based on type
    case "$1" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            echo "Error: Invalid version increment type. Use major, minor, or patch."
            exit 1
            ;;
    esac
    
    # Create new version string
    local new_version="${major}.${minor}.${patch}"
    echo "$new_version" > "$VERSION_FILE"
    echo "$new_version"
}

# Function to update version in all necessary files
update_version_in_files() {
    local new_version="$1"
    
    # Update main script
    sed -i "s/VERSION=\".*\"/VERSION=\"$new_version\"/" apptray
    
    # Update build script
    sed -i "s/VERSION=\".*\"/VERSION=\"$new_version\"/" build_apptray_deb.sh
    
    echo "Updated version to $new_version in all files"
}

# Main logic
case "$1" in
    get)
        get_version
        ;;
    major|minor|patch)
        new_version=$(increment_version "$1")
        update_version_in_files "$new_version"
        ;;
    *)
        echo "Usage: $0 {get|major|minor|patch}"
        echo "  get   - Show current version"
        echo "  major - Increment major version (X.0.0)"
        echo "  minor - Increment minor version (x.X.0)"
        echo "  patch - Increment patch version (x.x.X)"
        exit 1
        ;;
esac 
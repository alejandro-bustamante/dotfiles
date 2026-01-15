#!/bin/bash
set -e

DOTFILES_REPO="https://github.com/alejandro-bustamante/dotfiles.git"
REMOTE_MANIFEST_URL="https://raw.githubusercontent.com/alejandro-bustamante/dotfiles/test-files/private_dot_config/comtrya/bootstrap-packages.yaml"
TEMP_MANIFEST_DIR="/tmp/comtrya-bootstrap"

echo "Starting System Bootstrap..."

echo "Installing Comtrya binary..."
if ! command -v comtrya &> /dev/null; then
    if ! command -v curl &> /dev/null; then
        echo "Error: curl is required to download Comtrya. Please install curl first."
        exit 1
    fi

    curl -L -o /tmp/comtrya https://github.com/comtrya/comtrya/releases/download/v0.9.2/comtrya-x86_64-unknown-linux-gnu
    chmod +x /tmp/comtrya
    sudo mv /tmp/comtrya /usr/local/bin/comtrya
    echo "Comtrya installed successfully."
fi

echo "Running Comtrya to install system dependencies (git, mega, chezmoi, keepassxc)..."
mkdir -p "$TEMP_MANIFEST_DIR"
curl -sL "$REMOTE_MANIFEST_URL" -o "$TEMP_MANIFEST_DIR/bootstrap-packages.yaml"

sudo comtrya -d "$TEMP_MANIFEST_DIR" apply -m bootstrap-packages

rm -rf "$TEMP_MANIFEST_DIR"

if command -v chezmoi &> /dev/null; then
    echo "Initializing chezmoi..."
    chezmoi init --apply --verbose "$DOTFILES_REPO"
else
    echo "Error: Chezmoi was not installed by Comtrya. Aborting."
    exit 1
fi

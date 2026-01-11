#!/bin/bash
set -e

DOTFILES_REPO="https://github.com/alejandro-bustamante/dotfiles.git"

echo "Starting System Bootstrap..."

# --- Function to install mega-cmd based on distro ---
install_megacmd() {
    echo "☁️ Installing mega-cmd..."
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case $ID in
            debian|ubuntu|pop|mint|kali)
                # Standard installation for Debian-based systems using the official .deb
                # Note: This is a simplified approach. For production, adding the repository is better.
                DISTRO_VERSION="${ID}_${VERSION_ID}"
                # Fallback for distros without direct version mapping on Mega (like Pop!_OS)
                if [[ "$ID" == "pop" ]]; then DISTRO_VERSION="xUbuntu_${VERSION_ID}"; fi
                if [[ "$ID" == "mint" ]]; then DISTRO_VERSION="xUbuntu_22.04"; fi # Adjust based on Mint base

                echo "   Detected $ID ($DISTRO_VERSION). Downloading .deb..."
                TEMP_DEB="$(mktemp).deb"
                # Generic download link construction (might need adjustment per specific version)
                wget -O "$TEMP_DEB" "https://mega.nz/linux/repo/xUbuntu_${VERSION_ID}/amd64/megacmd-xUbuntu_${VERSION_ID}_amd64.deb" || \
                wget -O "$TEMP_DEB" "https://mega.nz/linux/repo/Debian_${VERSION_ID}/amd64/megacmd-Debian_${VERSION_ID}_amd64.deb"
                
                sudo apt install -y "$TEMP_DEB"
                rm "$TEMP_DEB"
                ;;
            fedora)
                echo "   Detected Fedora. Installing rpm..."
                sudo dnf install -y https://mega.nz/linux/repo/Fedora_${VERSION_ID}/x86_64/megacmd-Fedora_${VERSION_ID}.x86_64.rpm
                ;;
            arch|manjaro|endeavouros|cachyos)
                echo "   Detected Arch-based. Checking for yay/paru..."
                if command -v yay &> /dev/null; then
                    yay -S --noconfirm megacmd-bin
                elif command -v paru &> /dev/null; then
                    paru -S --noconfirm megacmd-bin
                else
                    echo "AUR helper not found. Please install 'megacmd' manually from AUR."
                    read -p "Press Enter once installed..."
                fi
                ;;
            *)
                echo "Automatic mega-cmd installation not supported for this distro ($ID)."
                echo "   Please install 'mega-cmd' manually before proceeding."
                read -p "Press Enter to continue..."
                ;;
        esac
    fi
}

# --- 1. Install Dependencies (git, chezmoi, mega-cmd) ---
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case $ID in
        debian|ubuntu|pop|mint)
            sudo apt update && sudo apt install -y git
            if ! command -v chezmoi &> /dev/null; then
                sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "/usr/local/bin"
            fi
            ;;
        fedora)
            sudo dnf install -y git chezmoi
            ;;
        arch|manjaro|endeavouros|cachyos)
            sudo pacman -Sy --noconfirm git chezmoi
            ;;
        alpine)
            sudo apk add git chezmoi
            ;;
        *)
            echo "Distro not supported for automatic bootstrap."
            exit 1
            ;;
    esac
fi

# Install mega-cmd if missing
if ! command -v mega-get &> /dev/null; then
    install_megacmd
else
    echo "mega-cmd is already installed."
fi

# --- 2. Launch Chezmoi ---
echo "⚙️ Initializing chezmoi..."
chezmoi init --apply --verbose $DOTFILES_REPO

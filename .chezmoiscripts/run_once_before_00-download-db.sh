#!/bin/bash

# --- Configuration ---
DB_DIR="$HOME/vault/db"
KEY_DIR="$HOME/vault/key"
DB_FILE="$DB_DIR/db.kdbx"
URL_DB="https://mega.nz/file/CuZSSQqR#Na89z0EPvcj0U7u5qLZsxGYqGO8B11cu_qiA5JmteLs" 

echo "Starting Database Setup..."

# 1. Create directory structure
mkdir -p "$DB_DIR"
mkdir -p "$KEY_DIR"

echo "Directories created at:"
echo "   - DB:  $DB_DIR"
echo "   - Key: $KEY_DIR"
echo ""
echo "ACTION REQUIRED:"
echo "   If your KeepassXC database requires a keyfile, please place it inside '$KEY_DIR' now."

# Use /dev/tty to force interaction even if script is piped, though chezmoi handles this well.
read -p "   Press [Enter] to continue..." < /dev/tty

# 2. Check if DB already exists
if [ -f "$DB_FILE" ]; then
    echo "Database found at $DB_FILE. Skipping download."
    exit 0
fi

# 3. Download from Mega
echo "Downloading database from Mega..."

if command -v mega-get &> /dev/null; then
    cd "$DB_DIR" || exit 1
    
    # mega-get downloads to current dir by default or requires path
    mega-get "$URL_DB"
    
    # Check if download was successful (mega-get might not return standard error codes)
    if [ -f "$DB_FILE" ] || [ -f *.kdbx ]; then 
        echo "Database successfully downloaded."
        chmod 600 "$DB_DIR"/*.kdbx
    else
        echo "Error: Download failed or file not found."
        exit 1
    fi
else
    echo "Error: 'mega-get' command not found. Please ensure mega-cmd is installed."
    exit 1
fi

#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Enforce execution only on Linux platforms
if [ "$(uname)" != "Linux" ]; then
    echo "Error: This script is only configured to run on Linux environments."
    exit 1
fi

# Check if sshpass is already available in the system path
if command -v sshpass &> /dev/null; then
    echo "sshpass is already installed."
else
    # Check and install for Debian/Ubuntu-based systems
    if [ -f /etc/debian_version ]; then
        sudo apt update && sudo apt install -y sshpass
    # Check and install for RedHat/CentOS/Fedora-based systems
    elif [ -f /etc/redhat-release ] || [ -f /etc/os-release ]; then
        sudo dnf install -y sshpass
    else
        echo "Linux distribution not fully recognized. Please install 'sshpass' manually."
    fi
fi

# Create the virtual environment if the directory doesn't exist
if [ ! -d ".venv" ]; then
    python3 -m venv .venv
    echo "Virtual environment '.venv' successfully created."
else
    echo "Virtual environment '.venv' already exists."
fi

# Activate the virtual environment locally to upgrade pip and install requirements
source .venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
echo "All Python dependencies installed successfully."

VAULT_FILE=".ansible_vault_pass"
# Safely create the local password file if missing
if [ ! -f "$VAULT_FILE" ]; then
    echo "A password is required to decrypt variables in this repository."
    # Securely read password input without echoing characters to the terminal
    read -sp "Enter password for Ansible Vault: " vault_pass
    echo ""
    
    # Write password to local hidden file
    echo "$vault_pass" > "$VAULT_FILE"
    # Set strict Linux permissions (chmod 600) so only the owner can read/write it
    chmod 600 "$VAULT_FILE"
    echo "Local '$VAULT_FILE' file created with restricted permissions."
else
    echo "The file '$VAULT_FILE' already exists."
fi
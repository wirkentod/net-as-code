#!/bin/bash
# init-runner.sh - Dynamic provisioning script for the production GitHub Runner host.
# This script must be executed with sudo privileges.
set -e

# Enforce root execution
if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run this script using sudo." >&2
  exit 1
fi

# Error Control: Ensure the user provided all required arguments
if [ $# -lt 1 ]; then
    echo "Error: Missing required arguments." >&2
    echo "Usage: sudo $0 <runner_username>" >&2
    echo "Example: sudo $0 github-runner" >&2
    exit 1
fi

# Runner user name
RUNNER_USER="$1"

# Automatically detect the current absolute path of the project dynamically
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "1. Checking system user: $RUNNER_USER"
if id "$RUNNER_USER" &>/dev/null; then
    echo "User '$RUNNER_USER' already exists."
else
    echo "Creating isolated system user: $RUNNER_USER..."
    useradd -m -s /bin/bash "$RUNNER_USER"
    echo "User '$RUNNER_USER' created successfully."
fi

echo "2. Target project directory detected at: $PROJECT_DIR"

echo "3. Securing directory and applying strict permissions for user '$RUNNER_USER'..."
# Change ownership exclusively to the dynamic user and their primary group
chown -R "$RUNNER_USER":"$RUNNER_USER" "$PROJECT_DIR"

# Enforce strict exclusive access to the project root folder (chmod 700)
chmod 700 "$PROJECT_DIR"

echo "4. Normalizing internal files and folder structure permissions..."
# Standard secure file permissions (644) and directory navigation permissions (755)
find "$PROJECT_DIR" -type f -exec chmod 644 {} +
find "$PROJECT_DIR" -type d -exec chmod 755 {} +

echo "5. Restoring execution bits to critical tools and scripts..."
# Re-enable execution permissions exclusively for scripts and the virtual env binaries
if [ -f "$PROJECT_DIR/setup.sh" ]; then
    chmod +x "$PROJECT_DIR/setup.sh"
fi

if [ -d "$PROJECT_DIR/.venv/bin" ]; then
    chmod -R +x "$PROJECT_DIR/.venv/bin/"
fi

echo "--------------------------------------------------"
echo "Hardening complete. The directory '$PROJECT_DIR' is now secure."
echo "   Next step: Switch context to your secure user and complete setup:"
echo "   sudo -i -u $RUNNER_USER"
echo "   cd $PROJECT_DIR"
echo "   source setup.sh vars_secrets.yaml"
echo "--------------------------------------------------"
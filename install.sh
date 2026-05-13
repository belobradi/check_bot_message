#!/bin/bash

SERVICE_NAME="check_bot_message.service"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME"

# Capture current environment variables
USER_NAME=${USER:-$(whoami)}
CURRENT_DIR=$(pwd)

echo "Initializing systemd service installation..."
echo "Service Name: $SERVICE_NAME"
echo "Target User:  $USER_NAME"
echo "Work Dir:     $CURRENT_DIR"

# Create the systemd unit file using a Heredoc
sudo tee $SERVICE_PATH > /dev/null <<EOF
[Unit]
Description=Telegram Bot Message Checker
After=network-online.target
Wants=network-online.target

[Service]
# Execute the service as the current user
User=$USER_NAME
# Set the working directory so the script can find the .env file
WorkingDirectory=$CURRENT_DIR
# Command to execute the bash script
ExecStart=/bin/bash $CURRENT_DIR/check_bot_message.sh
# Restart policy: always restart if the process exits or crashes
Restart=always
# Wait 5 seconds before restarting to prevent rapid-fire loops
RestartSec=5

[Install]
# Enable the service for a standard multi-user system setup
WantedBy=multi-user.target
EOF

# Create drop-in configuration for better startup ordering
# This ensures the service starts after local filesystems are mounted
DROP_IN_DIR="/etc/systemd/system/$SERVICE_NAME.d"
sudo mkdir -p "$DROP_IN_DIR"
sudo tee "$DROP_IN_DIR/override.conf" > /dev/null <<EOF
[Unit]
After=local-fs.target
EOF

# Ensure the main script has execution permissions
chmod +x "$CURRENT_DIR/check_bot_message.sh"

echo "Reloading systemd manager configuration..."
sudo systemctl daemon-reload

echo "Enabling service to start on boot..."
sudo systemctl enable $SERVICE_NAME

echo "Restarting service to apply changes..."
sudo systemctl restart $SERVICE_NAME

echo "-------------------------------------------------------"
echo "Installation complete. Checking service status:"
systemctl status $SERVICE_NAME --no-pager
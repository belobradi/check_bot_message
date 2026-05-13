#!/bin/bash

SERVICE_NAME="check_bot_message.service"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME"

echo "Stopping and deactivating $SERVICE_NAME..."

# 1. Stop the service if running
sudo systemctl stop $SERVICE_NAME

# 2. Disable automatic run during system startup
sudo systemctl disable $SERVICE_NAME

# 3. Delete service file
if [ -f "$SERVICE_PATH" ]; then
    sudo rm "$SERVICE_PATH"
    echo "Service file is deleted."
else
    echo "Service file is not deleted."
fi

# 4. Reload systemd configuration to forget deleted service
sudo systemctl daemon-reload

# 5. Clean failed statuses
sudo systemctl reset-failed

echo "Deinstallation successfully completed."
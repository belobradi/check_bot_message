#!/bin/bash

SERVICE_NAME="check_bot_message.service"
SERVICE_PATH="/etc/systemd/system/$SERVICE_NAME"
CURRENT_DIR=$(pwd)
USER_NAME=$(whoami)

echo "Creating systemd servis..."

sudo tee $SERVICE_PATH > /dev/null <<EOF
[Unit]
Description=Telegram Bot Checker
After=network-online.target

[Service]
User=$USER_NAME
WorkingDirectory=$CURRENT_DIR
ExecStart=/bin/bash $CURRENT_DIR/check_bot_message.sh
Restart=always

[Install]
WantedBy=multi-user.target
EOF

echo "Service installation..."
sudo systemctl daemon-reload
sudo systemctl enable $SERVICE_NAME
sudo systemctl start $SERVICE_NAME

echo "Service is successfully installed and running!"
sudo systemctl status $SERVICE_NAME
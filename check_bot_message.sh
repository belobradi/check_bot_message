#!/bin/bash

# Reading .env
if [ -f .env ]; then
    set -a
    source "$(dirname "$0")/.env"
    set +a
else
    echo "Error: .env file is not found!"
    exit 1
fi

# ID of the last read message (to not process whole history)
OFFSET_FILE="/tmp/tg_bot_offset"
[ -f "$OFFSET_FILE" ] && OFFSET=$(cat "$OFFSET_FILE") || OFFSET=0

echo "Bot is running and waiting for a command..."

while true; do
    # Message check through Telegram API
    RESPONSE=$(curl -s "https://api.telegram.org/bot$TOKEN/getUpdates?offset=$OFFSET&timeout=30")
    
    # Message text and ID extraction
    MESSAGE_TEXT=$(echo "$RESPONSE" | grep -oP '(?<="text":")[^"]+' | tail -n 1)
    UPDATE_ID=$(echo "$RESPONSE" | grep -oP '(?<="update_id":)\d+' | tail -n 1)

    if [ ! -z "$UPDATE_ID" ]; then
        OFFSET=$((UPDATE_ID + 1))
        echo "$OFFSET" > "$OFFSET_FILE"

        if [ "$MESSAGE_TEXT" == "/ip" ]; then
            CURRENT_IP=$(curl -s -4 ifconfig.me)
            
            echo "Command recieved. Sending an IP: $CURRENT_IP"
            
            curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
                 -d "chat_id=$CHAT_ID" \
                 -d "text=Current IP address is: $CURRENT_IP" > /dev/null
        else
            curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
                 -d "chat_id=$CHAT_ID" \
                 -d "text=Command is not recognized." > /dev/null
        fi
    fi
    
    sleep 1
done
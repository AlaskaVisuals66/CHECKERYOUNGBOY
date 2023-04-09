#!/bin/bash

# Replace with your bot token
export CHATGPT_TOKEN="6171128157:AAEAuEbjtwzqgeaSPtyYU7T5Mi5xdCKAcg4"

# Replace with the path to chatgpt_bypass.sh
CHATGPT_SCRIPT="/storage/emulated/0/chatgpt/chatgpt_bypass.sh"

# Function to send a message using the Telegram bot API
function send_message {
  local chat_id="$1"
  local text="$2"
  curl -s -X POST "https://api.telegram.org/bot${CHATGPT_TOKEN}/sendMessage" -d "chat_id=${chat_id}&text=${text}"
}

# Main loop to receive messages and respond to them
while true; do
  # Use the Telegram bot API to get updates
  response=$(curl -s "https://api.telegram.org/bot${CHATGPT_TOKEN}/getUpdates")

  # Extract the chat ID and text of the most recent message
  chat_id=$(echo "$response" | jq -r '.result[-1].message.chat.id')
  message=$(echo "$response" | jq -r '.result[-1].message.text')

  # Ignore messages that are not text
  if [[ "$message" == "" || "$message" == "/"* ]]; then
    continue
  fi

  # Send the message to chatgpt_bypass.sh and get the response
  response=$("$CHATGPT_SCRIPT" "$message")
  
  # Send the response back to the chat
  send_message "$chat_id" "$response"
done
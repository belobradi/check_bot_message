# Telegram Remote IP Checker Bot

A lightweight Bash-based Telegram bot that runs as a persistent background `systemd` service on Linux. It listens for a specific command (`/ip`) and replies with the host machine's current public IPv4 address. 

This is incredibly useful for tracking the public IP of remote servers, home labs, or Raspberry Pi setups that are behind dynamic IPs without needing a full dynamic DNS setup.

---

## Features

* **Lightweight:** Written entirely in Bash; no heavy runtimes (like Python or Node.js) required.
* **Persistent:** Bundled with an automatic installer that configures it as a `systemd` service.
* **Resilient:** Automatically restarts if it crashes or if the network drops.
* **Secure:** Keeps sensitive API tokens isolated in a `.env` file.

---

## Prerequisites

Before setup, make sure you have:
1. A Linux machine running `systemd` (Debian, Ubuntu, Fedora, etc.).
2. `curl` installed.
3. A Telegram Bot Token (generated via [@BotFather](https://t.me/BotFather))[cite: 3].
4. Your Telegram `chat_id` (you can get this from bots like [@userinfobot](https://t.me/userinfobot))[cite: 3].

---

## Installation & Setup

### 1. Clone the Repository
Clone this repository to your target machine and navigate into the directory:
```bash
git clone [https://github.com/yourusername/your-repo-name.git](https://github.com/yourusername/your-repo-name.git)
cd your-repo-name
```
### 2. Configure Environment Variables
Create a file named `.env` in the root of the project directory:
```bash
nano .env
```
Add your Telegram Bot details to the file:
```bash
TOKEN="your_telegram_bot_token_here"
CHAT_ID="your_personal_telegram_chat_id"
```
Save and exit (in Nano, press `Ctrl+O`, `Enter`, then `Ctrl+X`).

### 3. Run the Installer
The project includes an automation script that creates the background service, handles permissions, and starts it up. Run `install.sh`:
```bash
chmod +x install.sh
./install.sh
```
The script will output the active status of the service upon successful installation.

## Usage
Once installed, open your Telegram chat with the bot and send the following command:
* `/ip` - The bot will query `ifconfig.me` and reply with the machine's current public IP.
* Any other message will result in a `"Command is not recognized."` response.

## Service Management
Since the bot runs via `systemd`, you can manage it using standard system commands:

Check the status:
```bash
sudo systemctl status check_bot_message.service
```
View live logs (troubleshooting):
```bash
sudo journalctl -u check_bot_message.service -f
```
Restart the service:
```bash
sudo systemctl restart check_bot_message.service
```
Stop the service:
```bash
sudo systemctl stop check_bot_message.service
```

## Uninstallation
If you want to completely remove the service and clean up your system configuration, simply run the provided uninstallation script:
```bash
chmod +x uninstall.sh
./uninstall.sh
```
This will stop the service, disable it from launching at boot, delete the `systemd` configuration files, and reload the manager daemon cleanly.

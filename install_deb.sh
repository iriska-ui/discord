#!/bin/bash
# install-simple.sh - Version sans menu

echo "🎮 Installation de Discord et Steam"
echo "=================================="

sudo apt update && sudo apt upgrade -y

# Discord
wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"
sudo dpkg -i /tmp/discord.deb
sudo apt-get install -f -y
rm /tmp/discord.deb

# Steam
sudo dpkg --add-architecture i386
sudo apt update
sudo apt install -y steam-installer

echo "✅ Installation terminée !"

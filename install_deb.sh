#!/bin/bash
# Installation de Discord via .deb officiel

echo "🎤 Installation de Discord"
echo "=========================="

# Téléchargement
echo "⬇️ Téléchargement du .deb officiel..."
wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"

# Installation
echo "📦 Installation..."
sudo dpkg -i /tmp/discord.deb || sudo apt-get install -f -y

# Nettoyage
rm /tmp/discord.deb

echo "✅ Discord installé !"
echo "🚀 Lance-le depuis le menu applications"

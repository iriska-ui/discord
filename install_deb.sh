#!/bin/bash
# Installation de Discord (téléchargement + installation + nettoyage)

echo "🎤 Installation de Discord"
echo "=========================="

# Téléchargement
echo "⬇️ Téléchargement du .deb officiel..."
wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"

# Vérification
if [ ! -f /tmp/discord.deb ]; then
    echo "❌ Échec du téléchargement"
    exit 1
fi

# Installation
echo "📦 Installation..."
sudo dpkg -i /tmp/discord.deb || sudo apt-get install -f -y

# Nettoyage
echo "🧹 Nettoyage..."
rm /tmp/discord.deb

echo "✅ Discord installé !"
echo "🚀 Lance-le depuis le menu applications"

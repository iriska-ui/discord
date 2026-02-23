#!/bin/bash
# Installation de Discord (avec fallback curl)

echo "🎤 Installation de Discord"
echo "=========================="

# Détection et téléchargement
echo "⬇️ Téléchargement du .deb officiel..."


if command -v curl >/dev/null 2>&1; then
    curl -L -o /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"


# Vérification
if [ ! -f /tmp/discord.deb ]; then
    echo "❌ Échec du téléchargement"
    exit 1
fi

# Installation
echo "📦 Installation..."
sudo dpkg -i /tmp/discord.deb 2>/dev/null || sudo apt-get install -f -y

# Nettoyage
rm -f /tmp/discord.deb

echo "✅ Discord installé !"
echo "🚀 Lance-le depuis le menu applications"

 #!/bin/bash
# Installation de Discord (avec fallback curl)

echo "🎤 Installation de Discord"
echo "=========================="

# Détection et téléchargement
echo "⬇️ Téléchargement du .deb officiel..."

curl -L -o /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb"

# Installation
echo "📦 Installation..."
sudo dpkg -i /tmp/discord.deb 2>/dev/null || sudo apt-get install -f -y

# Nettoyage
rm -f /tmp/discord.deb

#!/bin/bash

# ==============================================
# INSTALLATEUR DISCORD & STEAM - VERSION CORRIGÉE
# ==============================================

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# Fichier de log
LOG_FILE="/tmp/install-games-$(date +%Y%m%d-%H%M%S).log"

# ==============================================
# FONCTIONS
# ==============================================

log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

update_system() {
    echo -e "${YELLOW}📦 Mise à jour du système...${NC}"
    sudo apt update >> "$LOG_FILE" 2>&1
    sudo apt upgrade -y >> "$LOG_FILE" 2>&1
    echo -e "${GREEN}✅ Système à jour${NC}"
}

install_discord() {
    echo -e "${YELLOW}📦 Installation de Discord...${NC}"
    
    # Téléchargement
    wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb" >> "$LOG_FILE" 2>&1
    
    # Installation
    sudo dpkg -i /tmp/discord.deb >> "$LOG_FILE" 2>&1
    sudo apt-get install -f -y >> "$LOG_FILE" 2>&1
    
    # Nettoyage
    rm /tmp/discord.deb
    
    echo -e "${GREEN}✅ Discord installé !${NC}"
}

install_steam() {
    echo -e "${YELLOW}🎮 Installation de Steam...${NC}"
    
    # Architecture i386
    sudo dpkg --add-architecture i386 >> "$LOG_FILE" 2>&1
    sudo apt update >> "$LOG_FILE" 2>&1
    
    # Installation
    sudo apt-get install -y steam-installer >> "$LOG_FILE" 2>&1
    
    echo -e "${GREEN}✅ Steam installé !${NC}"
}

show_menu() {
    clear
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo -e "${PURPLE}      INSTALLATEUR DISCORD & STEAM${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo ""
    echo "1) 📦 Installer Discord uniquement"
    echo "2) 🎮 Installer Steam uniquement"
    echo "3) ⚡ Installer les deux"
    echo "4) ❌ Quitter"
    echo ""
    echo -e "${BLUE}════════════════════════════════════════${NC}"
    echo ""
}

# ==============================================
# PROGRAMME PRINCIPAL
# ==============================================

# Vérifications
if ! sudo -v >/dev/null 2>&1; then
    echo -e "${RED}❌ Droits sudo requis${NC}"
    exit 1
fi

# Mise à jour initiale
update_system

# Menu principal
while true; do
    show_menu
    echo -n "Choisis une option (1-4) : "
    read -r CHOICE
    
    case $CHOICE in
        1)
            clear
            echo -e "${BLUE}=== Installation de Discord ===${NC}"
            install_discord
            echo ""
            echo -n "Appuie sur Entrée pour continuer..."
            read -r
            ;;
        2)
            clear
            echo -e "${BLUE}=== Installation de Steam ===${NC}"
            install_steam
            echo ""
            echo -n "Appuie sur Entrée pour continuer..."
            read -r
            ;;
        3)
            clear
            echo -e "${PURPLE}=== Installation des deux ===${NC}"
            install_discord
            echo ""
            install_steam
            echo ""
            echo -n "Appuie sur Entrée pour continuer..."
            read -r
            ;;
        4)
            echo -e "${GREEN}👋 Au revoir !${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Option invalide ! Appuie sur Entrée pour réessayer${NC}"
            read -r
            ;;
    esac
done

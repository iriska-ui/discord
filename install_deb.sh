#!/bin/bash

# ==============================================
# INSTALLATEUR DISCORD & STEAM
# ==============================================

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Fichier de log
LOG_FILE="/tmp/install-games-$(date +%Y%m%d-%H%M%S).log"

# ==============================================
# FONCTIONS UTILITAIRES
# ==============================================

log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

show_menu() {
    clear
    log "${BLUE}════════════════════════════════════════${NC}"
    log "${PURPLE}      INSTALLATEUR DISCORD & STEAM${NC}"
    log "${BLUE}════════════════════════════════════════${NC}"
    log ""
    log "1) 📦 Installer Discord uniquement"
    log "2) 🎮 Installer Steam uniquement"
    log "3) ⚡ Installer Discord ET Steam"
    log "4) ❌ Quitter"
    log ""
    log "${BLUE}════════════════════════════════════════${NC}"
}

update_system() {
    log "${YELLOW}📦 Mise à jour des dépôts (apt update)...${NC}"
    sudo apt update 2>&1 | tee -a "$LOG_FILE"
    
    log "${YELLOW}📦 Mise à jour des paquets (apt upgrade)...${NC}"
    sudo apt upgrade -y 2>&1 | tee -a "$LOG_FILE"
    
    log "${GREEN}✅ Système à jour !${NC}"
}

install_discord() {
    log "${YELLOW}📦 Installation de Discord...${NC}"
    
    # Vérifier si Discord est déjà installé
    if dpkg -l | grep -q discord; then
        log "${YELLOW}⚠️ Discord est déjà installé. Voulez-vous le réinstaller ? (o/N)${NC}"
        read -r REINSTALL
        if [[ ! "$REINSTALL" =~ ^[OoYy]$ ]]; then
            log "${BLUE}⏭️ Installation de Discord ignorée${NC}"
            return
        fi
    fi
    
    # Téléchargement
    log "⬇️ Téléchargement du .deb officiel..."
    wget -O /tmp/discord.deb "https://discord.com/api/download?platform=linux&format=deb" 2>&1 | tee -a "$LOG_FILE" || {
        log "${RED}❌ Échec du téléchargement${NC}"
        return 1
    }
    
    # Installation
    log "📦 Installation..."
    sudo dpkg -i /tmp/discord.deb >> "$LOG_FILE" 2>&1
    sudo apt-get install -f -y >> "$LOG_FILE" 2>&1
    
    # Nettoyage
    rm /tmp/discord.deb
    
    log "${GREEN}✅ Discord installé avec succès !${NC}"
}

install_steam() {
    log "${YELLOW}🎮 Installation de Steam...${NC}"
    
    # Vérifier si Steam est déjà installé
    if dpkg -l | grep -q steam; then
        log "${YELLOW}⚠️ Steam est déjà installé. Voulez-vous le réinstaller ? (o/N)${NC}"
        read -r REINSTALL
        if [[ ! "$REINSTALL" =~ ^[OoYy]$ ]]; then
            log "${BLUE}⏭️ Installation de Steam ignorée${NC}"
            return
        fi
    fi
    
    # Ajout de l'architecture i386 si nécessaire
    log "🔧 Configuration de l'architecture 32 bits..."
    sudo dpkg --add-architecture i386 >> "$LOG_FILE" 2>&1
    sudo apt update >> "$LOG_FILE" 2>&1
    
    # Installation des dépendances
    log "📦 Installation des pilotes et dépendances (peut être long)..."
    sudo apt-get install -y \
        steam-installer \
        libgl1-mesa-glx:i386 \
        libgl1-mesa-dri:i386 \
        libc6:i386 \
        libxtst6:i386 \
        libxrandr2:i386 \
        libglib2.0-0:i386 \
        libgtk2.0-0:i386 \
        libpulse0:i386 \
        libgdk-pixbuf2.0-0:i386 \
        libcurl4-gnutls-dev:i386 \
        libopenal1:i386 \
        libusb-1.0-0:i386 \
        libnm0:i386 \
        libdbus-glib-1-2:i386 \
        libnm-glib4:i386 >> "$LOG_FILE" 2>&1
    
    log "${GREEN}✅ Steam installé avec succès !${NC}"
}

install_both() {
    log "${PURPLE}⚡ Installation de Discord ET Steam...${NC}"
    log ""
    install_discord
    log ""
    install_steam
}

check_sudo() {
    if ! sudo -v >/dev/null 2>&1; then
        log "${RED}❌ Ce script nécessite les droits sudo${NC}"
        exit 1
    fi
}

check_internet() {
    if ! ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        log "${RED}❌ Pas de connexion internet détectée${NC}"
        exit 1
    fi
}

check_system() {
    if ! command -v apt-get >/dev/null 2>&1; then
        log "${RED}❌ Ce script nécessite un système basé sur Debian/Ubuntu${NC}"
        exit 1
    fi
}

show_summary() {
    log ""
    log "${CYAN}════════════════════════════════════════${NC}"
    log "${GREEN}✅ Installation terminée !${NC}"
    log "${CYAN}════════════════════════════════════════${NC}"
    log "📝 Log sauvegardé dans : $LOG_FILE"
    log ""
    log "📦 Applications installées :"
    
    if dpkg -l | grep -q discord; then
        DISCORD_VER=$(dpkg -l | grep discord | awk '{print $3}')
        log "  • Discord : ${GREEN}$DISCORD_VER${NC}"
    fi
    
    if dpkg -l | grep -q steam; then
        STEAM_VER=$(dpkg -l | grep steam | awk '{print $3}')
        log "  • Steam : ${GREEN}$STEAM_VER${NC}"
    fi
    
    log ""
    log "${YELLOW}🚀 Redémarrage recommandé pour finaliser l'installation${NC}"
    log "${CYAN}════════════════════════════════════════${NC}"
}

# ==============================================
# PROGRAMME PRINCIPAL
# ==============================================

# Vérifications initiales
clear
log "${BLUE}🔍 Vérification du système...${NC}"
check_system
check_sudo
check_internet

# Mise à jour du système
log ""
log "${YELLOW}⚡ Mise à jour du système avant installation...${NC}"
update_system

# Menu principal
while true; do
    show_menu
    log ""
    echo -n "Choisis une option (1-4) : "
    read -r CHOICE
    
    case $CHOICE in
        1)
            clear
            log "${BLUE}=== Installation de Discord ===${NC}"
            install_discord
            show_summary
            log ""
            echo -n "Appuie sur Entrée pour continuer..."
            read
            ;;
        2)
            clear
            log "${BLUE}=== Installation de Steam ===${NC}"
            install_steam
            show_summary
            log ""
            echo -n "Appuie sur Entrée pour continuer..."
            read
            ;;
        3)
            clear
            log "${PURPLE}=== Installation complète ===${NC}"
            install_both
            show_summary
            log ""
            echo -n "Appuie sur Entrée pour continuer..."
            read
            ;;
        4)
            log "${BLUE}👋 Au revoir !${NC}"
            log "📝 Log disponible ici : $LOG_FILE"
            exit 0
            ;;
        *)
            log "${RED}❌ Option invalide !${NC}"
            sleep 1
            ;;
    esac
done

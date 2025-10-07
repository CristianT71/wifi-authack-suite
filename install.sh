#!/bin/bash

# install.sh - Script de instalación para wifi-authack

# Colores para la salida de la terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}[+] Iniciando la instalación de wifi-authack...${NC}"

# Función para verificar si un comando existe
command_exists () {
  command -v "$1" >/dev/null 2>&1
}

# Función para instalar paquetes
install_package () {
  PACKAGE_NAME=$1
  if ! command_exists "$PACKAGE_NAME"; then
    echo -e "${YELLOW}[*] Instalando ${PACKAGE_NAME}...${NC}"
    if command_exists "apt"; then
      sudo apt update && sudo apt install -y "$PACKAGE_NAME"
    elif command_exists "dnf"; then
      sudo dnf install -y "$PACKAGE_NAME"
    elif command_exists "pacman"; then
      sudo pacman -Sy --noconfirm "$PACKAGE_NAME"
    else
      echo -e "${RED}[-] No se encontró un gestor de paquetes compatible para instalar ${PACKAGE_NAME}. Por favor, instálelo manualmente.${NC}"
      exit 1
    fi
  else
    echo -e "${GREEN}[+] ${PACKAGE_NAME} ya está instalado.${NC}"
  fi
}

# Herramientas principales
install_package aircrack-ng
install_package wifite
install_package reaver
install_package bully
install_package hashcat

# Herramientas de estética
install_package figlet
install_package toilet
install_package lolcat

# Verificar otras dependencias (no se instalan directamente, solo se comprueba su existencia)
echo -e "${YELLOW}[*] Verificando otras dependencias...${NC}"

DEPENDENCIES=("iwlist" "nmcli" "airodump-ng" "airmon-ng" "aireplay-ng" "wash" "iwconfig")
for dep in "${DEPENDENCIES[@]}"; do
  if ! command_exists "$dep"; then
    echo -e "${RED}[-] Advertencia: La herramienta '${dep}' no se encontró. Algunas funcionalidades podrían no operar correctamente.${NC}"
  else
    echo -e "${GREEN}[+] '${dep}' encontrado.${NC}"
  fi
done

echo -e "${GREEN}[+] Instalación completada. Ejecute './audit.sh' para iniciar wifi-authack.${NC}"


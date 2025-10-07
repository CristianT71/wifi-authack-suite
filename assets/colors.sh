#!/bin/bash

# colors.sh - Funciones para la salida de color en la terminal

# Colores estándar
if [ -n "${WIFI_AUTHACK_COLORS_LOADED+x}" ]; then
	# Si se ejecuta directamente en vez de source, salir silenciosamente
	return 0 2>/dev/null || exit 0
fi
WIFI_AUTHACK_COLORS_LOADED=1

export C_RED='\033[0;31m'
export C_GREEN='\033[0;32m'
export C_YELLOW='\033[0;33m'
export C_BLUE='\033[0;34m'
export C_MAGENTA='\033[0;35m'
export C_CYAN='\033[0;36m'
export C_WHITE='\033[0;37m'
export C_NC='\033[0m' # No Color

# Estilos
export C_BOLD='\033[1m'
export C_UNDERLINE='\033[4m'

# Funciones de ayuda para imprimir con color
print_red() { echo -e "${C_RED}$1${C_NC}"; }
print_green() { echo -e "${C_GREEN}$1${C_NC}"; }
print_yellow() { echo -e "${C_YELLOW}$1${C_NC}"; }
print_blue() { echo -e "${C_BLUE}$1${C_NC}"; }
print_magenta() { echo -e "${C_MAGENTA}$1${C_NC}"; }
print_cyan() { echo -e "${C_CYAN}$1${C_NC}"; }
print_white() { echo -e "${C_WHITE}$1${C_NC}"; }

print_bold() { echo -e "${C_BOLD}$1${C_NC}"; }
print_underline() { echo -e "${C_UNDERLINE}$1${C_NC}"; }

# Ejemplo de uso:
# source ./assets/colors.sh
# print_green "Este es un mensaje verde."
# echo "${C_RED}Este es un mensaje rojo directamente.${C_NC}"


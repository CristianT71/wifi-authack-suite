#!/bin/bash

# audit.sh - Script principal para wifi-authack

# Cargar funciones de color (resolviendo la ruta del script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/assets/colors.sh"

# Función para mostrar el banner
show_banner() {
  if command -v toilet &> /dev/null; then
    toilet -f standard --filter border --gay "wifi-authack"
  elif command -v figlet &> /dev/null; then
    figlet "wifi-authack"
  else
    cat ./assets/banner.txt
  fi
  echo -e "\n${C_BOLD}WiFi Audit & Attack Kit - For Ethical Hacking${C_NC}\n"
}

# Función para mostrar la advertencia legal
show_legal_warning() {
  clear
  show_banner
  print_red "================================================================================"
  print_red "                      ADVERTENCIA LEGAL Y TÉRMINOS DE USO                     "
  print_red "================================================================================"
  echo -e "\n${C_YELLOW}Esta herramienta ha sido desarrollada con fines educativos y de auditoría ética.${C_NC}"
  echo -e "${C_YELLOW}Su uso está condicionado al cumplimiento de las leyes locales y al consentimiento${C_NC}"
  echo -e "${C_YELLOW}explícito del propietario de la red. El autor no se hace responsable por el uso${C_NC}"
  echo -e "${C_YELLOW}indebido o ilegal de este software.${C_NC}\n"
  print_red "================================================================================"
  echo -e "\n${C_WHITE}Para continuar, debe aceptar estos términos. Escriba 'aceptar' para proceder:${C_NC}"
  read -p "Confirmación: " confirmation

  if [[ "$confirmation" != "aceptar" ]]; then
    print_red "Términos no aceptados. Saliendo..."
    exit 1
  fi
}

# Función principal del menú
main_menu() {
  while true; do
    clear
    show_banner
    print_green "================================================================================"
    print_green "                            MENÚ PRINCIPAL - wifi-authack                       "
    print_green "================================================================================"
    echo -e "\n${C_CYAN}Seleccione una opción:${C_NC}"
    echo -e "  ${C_YELLOW}1.${C_NC} Escaneo de redes WiFi (scan.sh)"
    echo -e "  ${C_YELLOW}2.${C_NC} Activar modo monitor (monitor.sh)"
    echo -e "  ${C_YELLOW}3.${C_NC} Captura de handshakes (handshake.sh)"
    echo -e "  ${C_YELLOW}4.${C_NC} Pruebas de desautenticación (deauth.sh)"
    echo -e "  ${C_YELLOW}5.${C_NC} Auditoría WPS (wps.sh)"
    echo -e "  ${C_YELLOW}6.${C_NC} Diagnóstico de compatibilidad (compatibility.sh)"
    echo -e "  ${C_YELLOW}7.${C_NC} Generación de reportes (report.sh)"
    echo -e "  ${C_YELLOW}8.${C_NC} Integración con herramientas externas (external.sh)"
    echo -e "  ${C_RED}0.${C_NC} Salir\n"
    print_green "================================================================================"

    read -p "Opción: " choice

    case $choice in
      1) ./modules/scan.sh ;;
      2) ./modules/monitor.sh ;;
      3) ./modules/handshake.sh ;;
      4) ./modules/deauth.sh ;;
      5) ./modules/wps.sh ;;
      6) ./modules/compatibility.sh ;;
      7) ./modules/report.sh ;;
      8) ./modules/external.sh ;;
      0) print_green "Saliendo de wifi-authack. ¡Hasta pronto!"; exit 0 ;;
      *) print_red "Opción inválida. Presione cualquier tecla para continuar..."; read -n 1 ;;
    esac
    print_blue "Presione cualquier tecla para volver al menú principal..."
    read -n 1
  done
}

# Ejecución
show_legal_warning
main_menu


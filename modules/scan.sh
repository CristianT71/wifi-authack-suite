#!/bin/bash

# scan.sh - Módulo para escanear redes WiFi

# Resolver la ruta del script y cargar colors.sh relativo a este archivo
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/../assets/colors.sh"

# Función para verificar si la interfaz está en modo monitor
is_monitor_mode() {
  INTERFACE=$1
  if iwconfig "$INTERFACE" | grep -q "Mode:Monitor"; then
    return 0 # Está en modo monitor
  else
    return 1 # No está en modo monitor
  fi
}

# Función para escanear redes con airodump-ng (requiere modo monitor)
scan_airodump() {
  print_yellow "[*] Escaneando redes WiFi con airodump-ng (requiere modo monitor). Presione Ctrl+C para detener."
  read -p "Ingrese la interfaz en modo monitor (ej. wlan0mon): " monitor_interface

  if ! is_monitor_mode "$monitor_interface"; then
    print_red "[-] La interfaz '$monitor_interface' no está en modo monitor. Por favor, active el modo monitor primero."
    return 1
  fi

  print_green "[+] Iniciando airodump-ng en '$monitor_interface'. Capturando datos en 'scan_results'."
  sudo airodump-ng "$monitor_interface" -w ../logs/scan_results --output-format csv,netxml
  print_green "[+] Escaneo con airodump-ng finalizado. Resultados guardados en ../logs/scan_results-*.csv y ../logs/scan_results-*.netxml"
}

# Función para escanear redes con iwlist (modo gestionado)
scan_iwlist() {
  print_yellow "[*] Escaneando redes WiFi con iwlist (modo gestionado)."
  read -p "Ingrese la interfaz de red (ej. wlan0): " network_interface

  if ! iwconfig "$network_interface" &> /dev/null; then
    print_red "[-] La interfaz '$network_interface' no existe o no es una interfaz inalámbrica."
    return 1
  fi

  print_green "[+] Iniciando escaneo con iwlist en '$network_interface'."
  sudo iwlist "$network_interface" scan | grep -E "ESSID|Quality|Encryption|Channel" | tee ../logs/iwlist_scan_$(date +%F_%H-%M-%S).txt
  print_green "[+] Escaneo con iwlist finalizado. Resultados guardados en ../logs/iwlist_scan_*.txt"
}

# Función para escanear redes con nmcli (modo gestionado)
scan_nmcli() {
  print_yellow "[*] Escaneando redes WiFi con nmcli (modo gestionado)."
  print_green "[+] Iniciando escaneo con nmcli."
  nmcli dev wifi list | tee ../logs/nmcli_scan_$(date +%F_%H-%M-%S).txt
  print_green "[+] Escaneo con nmcli finalizado. Resultados guardados en ../logs/nmcli_scan_*.txt"
}

# Menú del módulo de escaneo
scan_menu() {
  while true; do
    clear
    print_green "================================================================================"
    print_green "                          MÓDULO DE ESCANEO DE REDES WIFI                     "
    print_green "================================================================================"
    echo -e "\n${C_CYAN}Seleccione un método de escaneo:${C_NC}"
    echo -e "  ${C_YELLOW}1.${C_NC} Escaneo pasivo con airodump-ng (requiere modo monitor)"
    echo -e "  ${C_YELLOW}2.${C_NC} Escaneo activo con iwlist (modo gestionado)"
    echo -e "  ${C_YELLOW}3.${C_NC} Escaneo activo con nmcli (modo gestionado)"
    echo -e "  ${C_RED}0.${C_NC} Volver al menú principal\n"
    print_green "================================================================================"

    read -p "Opción: " scan_choice

    case $scan_choice in
      1) scan_airodump ;;
      2) scan_iwlist ;;
      3) scan_nmcli ;;
      0) break ;;
      *) print_red "Opción inválida. Presione cualquier tecla para continuar..."; read -n 1 ;;
    esac
    print_blue "Presione cualquier tecla para continuar..."
    read -n 1
  done
}

scan_menu


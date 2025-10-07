#!/bin/bash

# monitor.sh - Módulo para activar/desactivar el modo monitor

source ../assets/colors.sh

# Función para verificar si una interfaz existe
interface_exists() {
  ip link show "$1" &> /dev/null
}

# Función para verificar si una interfaz está en modo monitor
is_monitor_mode() {
  INTERFACE=$1
  if iwconfig "$INTERFACE" | grep -q "Mode:Monitor"; then
    return 0 # Está en modo monitor
  else
    return 1 # No está en modo monitor
  fi
}

# Función para activar el modo monitor con airmon-ng
activate_airmon_ng() {
  print_yellow "[*] Activando modo monitor con airmon-ng."
  read -p "Ingrese la interfaz inalámbrica (ej. wlan0): " wireless_interface

  if ! interface_exists "$wireless_interface"; then
    print_red "[-] La interfaz '$wireless_interface' no existe."
    return 1
  fi

  print_green "[+] Deteniendo procesos conflictivos y activando modo monitor en '$wireless_interface'."
  sudo airmon-ng check kill
  sudo airmon-ng start "$wireless_interface"

  # airmon-ng suele renombrar la interfaz a wlan0mon, verificar el nuevo nombre
  MONITOR_INTERFACE=$(iwconfig 2>/dev/null | grep "Mode:Monitor" | awk '{print $1}')

  if is_monitor_mode "$MONITOR_INTERFACE"; then
    print_green "[+] Modo monitor activado exitosamente en '$MONITOR_INTERFACE'."
    echo "La interfaz en modo monitor es: $MONITOR_INTERFACE" >> ../logs/monitor_mode_$(date +%F_%H-%M-%S).txt
  else
    print_red "[-] Fallo al activar el modo monitor con airmon-ng."
  fi
}

# Función para activar el modo monitor con iwconfig
activate_iwconfig() {
  print_yellow "[*] Activando modo monitor con iwconfig."
  read -p "Ingrese la interfaz inalámbrica (ej. wlan0): " wireless_interface

  if ! interface_exists "$wireless_interface"; then
    print_red "[-] La interfaz '$wireless_interface' no existe."
    return 1
  fi

  print_green "[+] Bajando la interfaz, configurando modo monitor y subiéndola."
  sudo ip link set "$wireless_interface" down
  sudo iwconfig "$wireless_interface" mode monitor
  sudo ip link set "$wireless_interface" up

  if is_monitor_mode "$wireless_interface"; then
    print_green "[+] Modo monitor activado exitosamente en '$wireless_interface'."
    echo "La interfaz en modo monitor es: $wireless_interface" >> ../logs/monitor_mode_$(date +%F_%H-%M-%S).txt
  else
    print_red "[-] Fallo al activar el modo monitor con iwconfig."
  fi
}

# Función para desactivar el modo monitor
deactivate_monitor_mode() {
  print_yellow "[*] Desactivando modo monitor."
  read -p "Ingrese la interfaz en modo monitor (ej. wlan0mon): " monitor_interface

  if ! interface_exists "$monitor_interface"; then
    print_red "[-] La interfaz '$monitor_interface' no existe."
    return 1
  fi

  if ! is_monitor_mode "$monitor_interface"; then
    print_yellow "[*] La interfaz '$monitor_interface' no parece estar en modo monitor."
    return 0
  fi

  print_green "[+] Desactivando modo monitor en '$monitor_interface' y reiniciando servicios de red."
  sudo airmon-ng stop "$monitor_interface"
  sudo systemctl restart NetworkManager
  sudo systemctl restart wpa_supplicant

  if ! is_monitor_mode "$monitor_interface"; then
    print_green "[+] Modo monitor desactivado exitosamente en '$monitor_interface'."
  else
    print_red "[-] Fallo al desactivar el modo monitor en '$monitor_interface'."
  fi
}

# Menú del módulo de modo monitor
monitor_menu() {
  while true; do
    clear
    print_green "================================================================================"
    print_green "                         MÓDULO DE ACTIVACIÓN MODO MONITOR                    "
    print_green "================================================================================"
    echo -e "\n${C_CYAN}Seleccione una opción:${C_NC}"
    echo -e "  ${C_YELLOW}1.${C_NC} Activar modo monitor (airmon-ng)"
    echo -e "  ${C_YELLOW}2.${C_NC} Activar modo monitor (iwconfig)"
    echo -e "  ${C_YELLOW}3.${C_NC} Desactivar modo monitor"
    echo -e "  ${C_RED}0.${C_NC} Volver al menú principal\n"
    print_green "================================================================================"

    read -p "Opción: " monitor_choice

    case $monitor_choice in
      1) activate_airmon_ng ;;
      2) activate_iwconfig ;;
      3) deactivate_monitor_mode ;;
      0) break ;;
      *) print_red "Opción inválida. Presione cualquier tecla para continuar..."; read -n 1 ;;
    esac
    print_blue "Presione cualquier tecla para continuar..."
    read -n 1
  done
}

monitor_menu


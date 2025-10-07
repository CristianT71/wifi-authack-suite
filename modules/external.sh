#!/bin/bash

# external.sh - Módulo para integración con herramientas externas

source ../assets/colors.sh

# Función para verificar si un comando existe
command_exists () {
  command -v "$1" >/dev/null 2>&1
}

# Función para ejecutar aircrack-ng
run_aircrack_ng() {
  if ! command_exists "aircrack-ng"; then
    print_red "[-] aircrack-ng no está instalado. Por favor, instálelo para usar esta función."
    return 1
  fi
  print_yellow "[*] Ejecutando aircrack-ng. Necesitará un archivo .cap con un handshake."
  read -p "Ingrese la ruta al archivo .cap (ej. ../logs/handshake-01.cap): " cap_file
  if [ -f "$cap_file" ]; then
    read -p "Ingrese la ruta al diccionario (ej. /usr/share/wordlists/rockyou.txt): " wordlist_file
    if [ -f "$wordlist_file" ]; then
      print_green "[+] Iniciando aircrack-ng con $cap_file y $wordlist_file."
      sudo aircrack-ng "$cap_file" -w "$wordlist_file" | tee ../logs/aircrack_$(date +%F_%H-%M-%S).log
    else
      print_red "[-] Archivo de diccionario no encontrado."
    fi
  else
    print_red "[-] Archivo .cap no encontrado."
  fi
}

# Función para ejecutar wifite
run_wifite() {
  if ! command_exists "wifite"; then
    print_red "[-] wifite no está instalado. Por favor, instálelo para usar esta función."
    return 1
  fi
  print_yellow "[*] Ejecutando wifite. Asegúrese de tener una interfaz en modo monitor."
  read -p "Ingrese la interfaz en modo monitor (ej. wlan0mon): " monitor_interface
  if iwconfig "$monitor_interface" | grep -q "Mode:Monitor"; then
    print_green "[+] Iniciando wifite en $monitor_interface."
    sudo wifite --mac --kill --skip-crack --power 0 --interface "$monitor_interface" | tee ../logs/wifite_$(date +%F_%H-%M-%S).log
  else
    print_red "[-] La interfaz \'$monitor_interface\' no está en modo monitor. Active el modo monitor primero."
  fi
}

# Función para ejecutar hashcat
run_hashcat() {
  if ! command_exists "hashcat"; then
    print_red "[-] hashcat no está instalado. Por favor, instálelo para usar esta función."
    return 1
  fi
  print_yellow "[*] Ejecutando hashcat. Necesitará un hash y un diccionario."
  read -p "Ingrese la ruta al archivo de hash (ej. hash.txt): " hash_file
  if [ -f "$hash_file" ]; then
    read -p "Ingrese la ruta al diccionario (ej. /usr/share/wordlists/rockyou.txt): " wordlist_file
    if [ -f "$wordlist_file" ]; then
      print_green "[+] Iniciando hashcat con $hash_file y $wordlist_file. (Modo WPA/WPA2: -m 2500)"
      sudo hashcat -m 2500 "$hash_file" "$wordlist_file" | tee ../logs/hashcat_$(date +%F_%H-%M-%S).log
    else
      print_red "[-] Archivo de diccionario no encontrado."
    fi
  else
    print_red "[-] Archivo de hash no encontrado."
  fi
}

# Menú del módulo de herramientas externas
external_menu() {
  while true; do
    clear
    print_green "================================================================================"
    print_green "                       MÓDULO DE HERRAMIENTAS EXTERNAS                        "
    print_green "================================================================================"
    echo -e "\n${C_CYAN}Seleccione una herramienta externa para ejecutar:${C_NC}"
    echo -e "  ${C_YELLOW}1.${C_NC} Ejecutar aircrack-ng (Cracking de WPA/WPA2)"
    echo -e "  ${C_YELLOW}2.${C_NC} Ejecutar wifite (Ataques automatizados)"
    echo -e "  ${C_YELLOW}3.${C_NC} Ejecutar hashcat (Cracking de hashes)"
    echo -e "  ${C_RED}0.${C_NC} Volver al menú principal\n"
    print_green "================================================================================"

    read -p "Opción: " ext_choice

    case $ext_choice in
      1) run_aircrack_ng ;;
      2) run_wifite ;;
      3) run_hashcat ;;
      0) break ;;
      *) print_red "Opción inválida. Presione cualquier tecla para continuar..."; read -n 1 ;;
    esac
    print_blue "Presione cualquier tecla para continuar..."
    read -n 1
  done
}

external_menu


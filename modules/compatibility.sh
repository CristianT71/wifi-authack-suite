#!/bin/bash

# compatibility.sh - Módulo para diagnóstico de compatibilidad WiFi

source ../assets/colors.sh

# Función para detectar chipset y drivers
detect_hardware() {
  print_yellow "[*] Detectando chipset y drivers de adaptadores WiFi..."
  echo -e "\n${C_BOLD}--- Adaptadores PCI/PCIe ---${C_NC}"
  lspci -k | grep -EA3 'Network controller|Wireless'
  echo -e "\n${C_BOLD}--- Adaptadores USB ---${C_NC}"
  lsusb -t | grep -i "wireless"
  echo -e "\n${C_GREEN}[+] Detección de hardware completada. Revise la salida para identificar su chipset y los drivers en uso.${C_NC}"
  echo "Detección de hardware ejecutada." >> ../logs/compatibility_$(date +%F_%H-%M-%S).txt
}

# Función para verificar módulos del kernel cargados
verify_kernel_modules() {
  print_yellow "[*] Verificando módulos del kernel relacionados con WiFi..."
  lsmod | grep -i "mac80211\|cfg80211\|ath\|rt2800\|rtl8187\|b43\|iwlwifi"
  echo -e "\n${C_GREEN}[+] Verificación de módulos completada. Asegúrese de que los módulos correctos para su adaptador estén cargados.${C_NC}"
  echo "Verificación de módulos del kernel ejecutada." >> ../logs/compatibility_$(date +%F_%H-%M-%S).txt
}

# Función para pruebas de compatibilidad con distros
check_distro_compatibility() {
  print_yellow "[*] Información sobre compatibilidad con distribuciones Linux (Kali, Parrot, Ubuntu)."
  echo -e "\n${C_WHITE}Para verificar la compatibilidad con distribuciones específicas como Kali Linux, Parrot OS o Ubuntu, se recomienda lo siguiente:${C_NC}"
  echo -e "  ${C_BLUE}- ${C_BOLD}Kali Linux / Parrot OS:${C_NC} Estas distribuciones están diseñadas para auditorías de seguridad y suelen incluir la mayoría de los drivers y herramientas necesarias preinstaladas. Si su adaptador funciona en estas, es muy probable que sea compatible."
  echo -e "  ${C_BLUE}- ${C_BOLD}Ubuntu:${C_NC} Ubuntu y otras distribuciones basadas en Debian/Ubuntu suelen requerir la instalación manual de algunos drivers o firmware, especialmente para adaptadores más nuevos o menos comunes. Verifique los repositorios `non-free` o `multiverse` si tiene problemas."
  echo -e "\n${C_YELLOW}Consejo:${C_NC} Busque en línea el modelo de su adaptador WiFi junto con el nombre de la distribución (ej. 'TP-Link TL-WN722N Kali Linux') para encontrar guías específicas de instalación de drivers."
  echo "Información de compatibilidad con distros proporcionada." >> ../logs/compatibility_$(date +%F_%H-%M-%S).txt
}

# Menú del módulo de compatibilidad
compatibility_menu() {
  while true; do
    clear
    print_green "================================================================================"
    print_green "                       MÓDULO DE DIAGNÓSTICO DE COMPATIBILIDAD                "
    print_green "================================================================================"
    echo -e "\n${C_CYAN}Seleccione una opción:${C_NC}"
    echo -e "  ${C_YELLOW}1.${C_NC} Detectar Chipset y Drivers"
    echo -e "  ${C_YELLOW}2.${C_NC} Verificar Módulos del Kernel Cargados"
    echo -e "  ${C_YELLOW}3.${C_NC} Información de Compatibilidad con Distros"
    echo -e "  ${C_RED}0.${C_NC} Volver al menú principal\n"
    print_green "================================================================================"

    read -p "Opción: " comp_choice

    case $comp_choice in
      1) detect_hardware ;;
      2) verify_kernel_modules ;;
      3) check_distro_compatibility ;;
      0) break ;;
      *) print_red "Opción inválida. Presione cualquier tecla para continuar..."; read -n 1 ;;
    esac
    print_blue "Presione cualquier tecla para continuar..."
    read -n 1
  done
}

compatibility_menu


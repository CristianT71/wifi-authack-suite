#!/bin/bash

# report.sh - Módulo para la generación de reportes

source ../assets/colors.sh

# Función para generar un reporte consolidado de todos los logs
generate_consolidated_report() {
  print_yellow "[*] Generando reporte consolidado de todos los logs disponibles."
  REPORT_FILE="../logs/consolidated_report_$(date +%F_%H-%M-%S).txt"
  CSV_REPORT_FILE="../logs/consolidated_report_$(date +%F_%H-%M-%S).csv"

  echo "Reporte Consolidado de wifi-authack - Fecha: $(date)" > "$REPORT_FILE"
  echo "===================================================" >> "$REPORT_FILE"
  echo "" >> "$REPORT_FILE"

  # Encabezado para el CSV
  echo "Timestamp,Module,Action,Details" > "$CSV_REPORT_FILE"

  for log_file in ../logs/*.txt ../logs/*.log ../logs/*.csv; do
    if [ -f "$log_file" ]; then
      FILENAME=$(basename "$log_file")
      MODULE_NAME=$(echo "$FILENAME" | cut -d'_' -f1)
      TIMESTAMP=$(echo "$FILENAME" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2}')

      echo "--- Contenido de $FILENAME ---" >> "$REPORT_FILE"
      cat "$log_file" >> "$REPORT_FILE"
      echo "" >> "$REPORT_FILE"

      # Para CSV, intentar parsear y añadir si es posible
      if [[ "$log_file" == *.csv ]]; then
        # Saltar la primera línea (encabezado) y añadir al CSV consolidado
        tail -n +2 "$log_file" | while IFS= read -r line; do
          echo "$TIMESTAMP,$MODULE_NAME,CSV_Entry,\"$line\"" >> "$CSV_REPORT_FILE"
        done
      else
        # Para TXT/LOG, añadir como una entrada simple
        while IFS= read -r line; do
          echo "$TIMESTAMP,$MODULE_NAME,Log_Entry,\"$line\"" >> "$CSV_REPORT_FILE"
        done < "$log_file"
      fi
    fi
  done

  print_green "[+] Reporte consolidado generado en: $REPORT_FILE"
  print_green "[+] Reporte CSV consolidado generado en: $CSV_REPORT_FILE"
}

# Función para ver logs específicos por módulo
view_module_logs() {
  print_yellow "[*] Mostrando logs por módulo."
  echo -e "\n${C_CYAN}Módulos con logs disponibles:${C_NC}"
  find ../logs/ -maxdepth 1 -type f -name "*.txt" -o -name "*.log" -o -name "*.csv" | sed 's|../logs/||' | cut -d'_' -f1 | sort -u

  read -p "Ingrese el nombre del módulo para ver sus logs (ej. scan): " module_name

  LOGS_FOUND=0
  for log_file in ../logs/${module_name}_*.txt ../logs/${module_name}_*.log ../logs/${module_name}_*.csv; do
    if [ -f "$log_file" ]; then
      print_blue "--- Contenido de $(basename "$log_file") ---"
      cat "$log_file"
      echo ""
      LOGS_FOUND=1
    fi
  done

  if [ $LOGS_FOUND -eq 0 ]; then
    print_red "[-] No se encontraron logs para el módulo '$module_name'."
  fi
}

# Menú del módulo de reportes
report_menu() {
  while true; do
    clear
    print_green "================================================================================"
    print_green "                            MÓDULO DE GENERACIÓN DE REPORTES                  "
    print_green "================================================================================"
    echo -e "\n${C_CYAN}Seleccione una opción:${C_NC}"
    echo -e "  ${C_YELLOW}1.${C_NC} Generar Reporte Consolidado (TXT y CSV)"
    echo -e "  ${C_YELLOW}2.${C_NC} Ver Logs por Módulo"
    echo -e "  ${C_RED}0.${C_NC} Volver al menú principal\n"
    print_green "================================================================================"

    read -p "Opción: " report_choice

    case $report_choice in
      1) generate_consolidated_report ;;
      2) view_module_logs ;;
      0) break ;;
      *) print_red "Opción inválida. Presione cualquier tecla para continuar..."; read -n 1 ;;
    esac
    print_blue "Presione cualquier tecla para continuar..."
    read -n 1
  done
}

report_menu


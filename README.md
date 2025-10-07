# wifi-authack

Una suite de auditoría WiFi para Linux, diseñada para hackers éticos, técnicos y estudiantes. Este proyecto es 100% funcional, modular, visual y ejecutable desde la terminal. Todas las funcionalidades incluidas tienen utilidad real, están documentadas y son técnicamente válidas.

## 🎯 Propósito

`wifi-authack` es una herramienta de auditoría y diagnóstico de redes WiFi, con un enfoque ético y educativo. Permite escanear, analizar, capturar paquetes, probar la seguridad WPS y generar reportes, siempre bajo consentimiento explícito y dentro del marco legal. El usuario debe aceptar los términos de uso antes de ejecutar cualquier módulo.

## ❌ Requisitos estrictos

*   No incluye funciones simuladas ni decorativas. Cada componente tiene una utilidad práctica y verificable.
*   No presenta menús falsos ni comandos que no se ejecuten realmente.
*   No es una herramienta básica ni de demostración; es **completa y avanzada**.
*   Cada módulo es **real, ejecutable y validado** en distribuciones Linux como Kali, Parrot y Ubuntu.

## 🧰 Funcionalidades

1.  **Escaneo de redes WiFi**
    *   Escaneo activo y pasivo (utilizando `iwlist`, `nmcli`, `airodump-ng`).
    *   Filtros por canal, intensidad de señal y tipo de cifrado.
    *   Detección de redes ocultas.

2.  **Activación de modo monitor**
    *   Activación mediante `airmon-ng` o `iwconfig`.
    *   Validación de compatibilidad de la interfaz de red.
    *   Reinicio seguro de la red y diagnóstico de módulos.

3.  **Captura de handshakes**
    *   Captura de handshakes WPA/WPA2 con `airodump-ng`.
    *   Verificación de la validez del handshake.
    *   Guardado automático con timestamp.

4.  **Pruebas de desautenticación (solo con permiso)**
    *   Envío de paquetes de desautenticación con `aireplay-ng`.
    *   Control de intensidad y duración del ataque.

5.  **Auditoría WPS**
    *   Escaneo de puntos de acceso con WPS habilitado usando `wash`.
    *   Pruebas de fuerza bruta con `reaver` o `bully`.
    *   Detección de bloqueo WPS.

6.  **Diagnóstico de compatibilidad**
    *   Detección de chipset y drivers de la tarjeta WiFi.
    *   Verificación de módulos del kernel cargados.
    *   Pruebas de compatibilidad con Kali, Parrot y Ubuntu.

7.  **Generación de reportes**
    *   Generación de logs en formatos `.txt` y `.csv`.
    *   Almacenamiento en la carpeta `/logs/` con fecha y hora.
    *   Exportación de resultados específicos por módulo.

8.  **Integración con herramientas externas**
    *   Soporte para `aircrack-ng`, `wifite`, `reaver`, `bully`, `hashcat`.
    *   Verificación de instalación y rutas de las herramientas.

9.  **Estética de terminal**
    *   Uso de ASCII art con `figlet` o `toilet`.
    *   Colores en la terminal con `tput` o `lolcat`.
    *   Menús interactivos con `select`, `read`, `case`.
    *   Animaciones de barra de carga.

10. **Pantalla de advertencia legal**
    *   Mensaje inicial con términos de uso y advertencia legal.
    *   Requiere aceptación explícita antes de ejecutar cualquier módulo.

## 📁 Estructura del proyecto

```
wifi-authack/
├── audit.sh               # Script principal con menú de opciones
├── install.sh             # Script de instalación de dependencias
├── LICENSE                # Licencia del proyecto (MIT)
├── README.md              # Documentación técnica y legal
├── assets/
│   ├── banner.txt         # ASCII art personalizado para el banner
│   ├── colors.sh          # Funciones de color para la terminal
├── logs/
│   └── audit_YYYY-MM-DD.csv # Ejemplo de archivo de log
└── modules/
    ├── scan.sh            # Módulo para escanear redes WiFi
    ├── monitor.sh         # Módulo para activar el modo monitor
    ├── handshake.sh       # Módulo para capturar handshakes WPA/WPA2
    ├── deauth.sh          # Módulo para pruebas de desautenticación
    ├── wps.sh             # Módulo para auditoría WPS
    ├── compatibility.sh   # Módulo para diagnóstico de compatibilidad
    ├── report.sh          # Módulo para generación de reportes
    └── external.sh        # Módulo para integración con herramientas externas
```

## 🧾 Licencia y advertencia

Este software se distribuye bajo la [Licencia MIT](LICENSE).

**Advertencia Legal:**

> Esta herramienta ha sido desarrollada con fines educativos y de auditoría ética. Su uso está condicionado al cumplimiento de las leyes locales y al consentimiento explícito del propietario de la red. El autor no se hace responsable por el uso indebido o ilegal de este software.

## 🧠 Estilo del código

*   **Modular, claro y comentado:** El código está organizado en módulos, es fácil de entender y está bien documentado.
*   **Validaciones en cada paso:** Se incluyen comprobaciones para asegurar la correcta ejecución y prevenir errores.
*   **Estética hacker real:** La interfaz de terminal es visualmente atractiva y funcional, sin elementos simulados.
*   **Compatible con distros Linux modernas:** Probado y funcional en Kali Linux, Parrot OS y Ubuntu.
*   **Sin funciones decorativas:** Cada línea de código tiene un propósito real y contribuye a la funcionalidad del proyecto.

## 🚀 Uso

1.  **Clonar el repositorio:**
    ```bash
    git clone https://github.com/CristianT71/wifi-authack-suite.git
    cd wifi-authack
    ```
2.  **Instalar dependencias:**
    ```bash
    chmod +x install.sh
    ./install.sh
    ```
3.  **Ejecutar la suite:**
    ```bash
    chmod +x audit.sh
    ./audit.sh
    ```

---

**Autor:** Cristian Trujillo


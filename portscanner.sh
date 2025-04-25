#!/bin/bash

# ========= CONFIGURACIÓN =========
log_file="port_scan.log"
last_target=""
last_start_port=0
last_end_port=0

# ========= FUNCIONES =========

print_main_menu() {
    echo "===== ESCÁNER DE PUERTOS ====="
    echo "1) Escanear puertos"
    echo "2) Ver último log"
    echo "3) Limpiar log"
    echo "4) Salir"
    echo "==============================="
}

scan_ports() {
    read -p "Ingresa la IP o dominio a escanear: " target
    if [[ -z "$target" ]]; then
        echo "Error: el objetivo no puede estar vacío."
        return
    fi

    read -p "Puerto inicial: " start_port
    read -p "Puerto final: " end_port

    if ! [[ "$start_port" =~ ^[0-9]+$ && "$end_port" =~ ^[0-9]+$ ]]; then
        echo "Error: los puertos deben ser valores numéricos."
        return
    fi

    if [ "$start_port" -gt "$end_port" ]; then
        echo "Error: el puerto inicial debe ser menor o igual que el final."
        return
    fi

    # Guardar últimos datos para repetir
    last_target="$target"
    last_start_port="$start_port"
    last_end_port="$end_port"

    scan_ports_core "$target" "$start_port" "$end_port"
    post_action_menu
}

scan_ports_core() {
    local target="$1"
    local start_port="$2"
    local end_port="$3"

    echo "===== Escaneo: $(date) =====" >> "$log_file"
    echo "Objetivo: $target | Puertos: $start_port a $end_port" >> "$log_file"
    echo "" >> "$log_file"

    echo "Escaneando $target desde el puerto $start_port hasta $end_port..."

    for ((port=start_port; port<=end_port; port++)); do
        if timeout 0.3 bash -c "echo > /dev/tcp/$target/$port" &>/dev/null; then
            echo "Puerto $port ABIERTO" | tee -a "$log_file"
        else
            echo "Puerto $port CERRADO o INACCESIBLE" >> "$log_file"
        fi
    done

    echo "Escaneo completado. Resultados guardados en $log_file"
}

repeat_last_scan() {
    if [[ -z "$last_target" ]]; then
        echo "No hay escaneo previo para repetir."
        return
    fi

    echo "Repitiendo escaneo anterior en $last_target ($last_start_port-$last_end_port)..."
    scan_ports_core "$last_target" "$last_start_port" "$last_end_port"
    post_action_menu
}

save_report_as() {
    read -p "Ingresa el nombre de archivo destino para el reporte: " filename
    if [[ -z "$filename" ]]; then
        echo "Error: el nombre no puede estar vacío."
        return
    fi
    cp "$log_file" "$filename" && echo "Reporte guardado como '$filename'" || echo "Error al guardar el reporte."
}

clear_log() {
    > "$log_file"
    echo "Log limpiado: $log_file"
}

post_action_menu() {
    echo -e "\n--- Opciones posteriores al escaneo ---"
    echo "1) Volver al menú principal"
    echo "2) Repetir el último escaneo"
    echo "3) Guardar reporte con otro nombre"
    echo "4) Limpiar log"
    echo "5) Salir"
    read -p "Elige una opción: " choice
    case $choice in
        1) return ;;
        2) repeat_last_scan ;;
        3) save_report_as ;;
        4) clear_log ;;
        5) echo "Hasta luego."; exit 0 ;;
        *) echo "Opción inválida." ;;
    esac
}

# ========= BUCLE PRINCIPAL =========

while true; do
    print_main_menu
    read -p "Selecciona una opción: " option
    case $option in
        1) scan_ports ;;
        2)
            if [[ -f "$log_file" ]]; then
                echo -e "\nÚltimo log ($log_file):"
                cat "$log_file"
            else
                echo "No hay log aún."
            fi
            ;;
        3) clear_log ;;
        4) echo "Hasta luego."; exit 0 ;;
        *) echo "Selección inválida. Intenta de nuevo." ;;
    esac
done

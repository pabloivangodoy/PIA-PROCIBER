#!/bin/bash

# ========= CONFIG =========
LOG_FILE="network_monitor.log"

# ========= FUNCTIONS =========

print_main_menu() {
    echo "===== Network Monitoring Tool ====="
    echo "1) Check connectivity (ping)"
    echo "2) Show network interfaces"
    echo "3) Show active connections"
    echo "4) Full scan and log"
    echo "5) Exit"
    echo "=================================="
}

check_connectivity() {
    read -p "Enter IP or hostname to ping: " host
    if ping -c 4 "$host" &> /dev/null; then
        echo "✅ Host $host is reachable."
        ping -c 4 "$host"
    else
        echo "❌ Error: Cannot reach $host."
    fi
}

show_interfaces() {
    echo "🔌 Network Interfaces:"
    if command -v ip &> /dev/null; then
        ip -br addr show
    elif command -v ifconfig &> /dev/null; then
        ifconfig
    else
        echo "❌ Neither 'ip' nor 'ifconfig' is available."
    fi
}

show_connections() {
    echo "🌐 Active Network Connections:"
    if command -v ss &> /dev/null; then
        ss -tunap
    elif command -v netstat &> /dev/null; then
        netstat -tunap
    else
        echo "❌ Neither 'ss' nor 'netstat' is available."
    fi
}

full_scan_and_log() {
    read -p "Enter host to ping: " host

    echo "===== Full Scan Started: $(date) =====" >> "$LOG_FILE"

    echo -e "\n[Connectivity to $host]:" >> "$LOG_FILE"
    ping -c 4 "$host" >> "$LOG_FILE" 2>&1

    echo -e "\n[Network Interfaces]:" >> "$LOG_FILE"
    ip -br addr show >> "$LOG_FILE" 2>&1

    echo -e "\n[Active Connections]:" >> "$LOG_FILE"
    ss -tunap >> "$LOG_FILE" 2>&1

    echo "✅ Full scan completed. Log saved to $LOG_FILE"
}

post_action_menu() {
    echo -e "\n--- Post Task Options ---"
    echo "1) Return to main menu"
    echo "2) View last log"
    echo "3) Exit"
    read -p "Choose an option: " choice
    case $choice in
        1) return ;;
        2) cat "$LOG_FILE" ;;
        3) exit 0 ;;
        *) echo "❌ Invalid option." ;;
    esac
}

# ========= MAIN LOOP =========
while true; do
    print_main_menu
    read -p "Choose an option: " option
    case $option in
        1) check_connectivity; post_action_menu ;;
        2) show_interfaces; post_action_menu ;;
        3) show_connections; post_action_menu ;;
        4) full_scan_and_log; post_action_menu ;;
        5) echo "👋 Exiting..."; exit 0 ;;
        *) echo "❌ Invalid selection. Try again." ;;
    esac
done

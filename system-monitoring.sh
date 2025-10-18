#!/bin/bash

# ============================================
# 🖥️  Advanced System Monitoring Tool (Bash)
# ============================================

LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/system_log.txt"
CPU_THRESHOLD=80
MEM_THRESHOLD=80
MAX_LOG_SIZE=5000 # in KB

# --- Colors ---
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"
BOLD="\e[1m"

# --- Setup ---
mkdir -p "$LOG_DIR"

# --- Functions ---

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

rotate_logs() {
    if [ -f "$LOG_FILE" ]; then
        size_kb=$(du -k "$LOG_FILE" | cut -f1)
        if (( size_kb > MAX_LOG_SIZE )); then
            mv "$LOG_FILE" "$LOG_FILE.old"
            echo "Log rotated at $(date)" > "$LOG_FILE"
        fi
    fi
}

get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8}'
}

get_memory_usage() {
    free | awk '/Mem/{printf("%.0f", $3/$2*100)}'
}

get_disk_usage() {
    df -h --total | awk '/total/{print $5}'
}

get_network_usage() {
    ip -s link | awk '/RX:/ {rx=$2} /TX:/ {tx=$2} END {print "RX: "rx" TX: "tx}'
}

get_uptime() {
    uptime -p
}

get_top_processes() {
    echo "Top 5 CPU-consuming processes:"
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 6
}

get_temperature() {
    if command -v sensors &> /dev/null; then
        sensors | grep -m 1 'temp1' | awk '{print $2}'
    else
        echo "N/A"
    fi
}

get_battery_status() {
    if [ -d "/sys/class/power_supply/BAT0" ]; then
        STATUS=$(cat /sys/class/power_supply/BAT0/status)
        CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
        echo "$STATUS ($CAPACITY%)"
    else
        echo "N/A"
    fi
}

check_alerts() {
    local cpu=$(get_cpu_usage)
    local mem=$(get_memory_usage)

    if (( ${cpu%.*} > CPU_THRESHOLD )); then
        log_message "⚠️  ALERT: High CPU Usage - ${cpu}%"
        echo -e "${RED}⚠️  High CPU Usage: ${cpu}%${RESET}"
    fi

    if (( ${mem%.*} > MEM_THRESHOLD )); then
        log_message "⚠️  ALERT: High Memory Usage - ${mem}%"
        echo -e "${RED}⚠️  High Memory Usage: ${mem}%${RESET}"
    fi
}

show_summary() {
    echo "=========================================="
    echo "     🧾 SYSTEM SUMMARY REPORT"
    echo "=========================================="
    echo "CPU Usage: $(get_cpu_usage)%"
    echo "Memory Usage: $(get_memory_usage)%"
    echo "Disk Usage: $(get_disk_usage)"
    echo "Temperature: $(get_temperature)"
    echo "Battery: $(get_battery_status)"
    echo "Network: $(get_network_usage)"
    echo "Uptime: $(get_uptime)"
    echo
    get_top_processes
    echo "=========================================="
}

# --- Execution ---

if [[ "$1" == "--summary" ]]; then
    show_summary
    exit 0
fi

refresh_rate=${1:-5}

while true; do
    clear
    echo -e "${BOLD}==========================================${RESET}"
    echo -e "${BOLD}     🖥️  ADVANCED SYSTEM MONITORING TOOL ${RESET}"
    echo -e "${BOLD}==========================================${RESET}"
    echo

    CPU=$(get_cpu_usage)
    MEM=$(get_memory_usage)
    DISK=$(get_disk_usage)
    TEMP=$(get_temperature)
    BATTERY=$(get_battery_status)
    NET=$(get_network_usage)
    UPTIME=$(get_uptime)

    # Colorize CPU and memory output
    if (( ${CPU%.*} > CPU_THRESHOLD )); then CPU_COLOR=$RED; else CPU_COLOR=$GREEN; fi
    if (( ${MEM%.*} > MEM_THRESHOLD )); then MEM_COLOR=$YELLOW; else MEM_COLOR=$GREEN; fi

    echo -e "CPU Usage:      ${CPU_COLOR}${CPU}%${RESET}"
    echo -e "Memory Usage:   ${MEM_COLOR}${MEM}%${RESET}"
    echo -e "Disk Usage:     $DISK"
    echo -e "Temperature:    $TEMP"
    echo -e "Battery:        $BATTERY"
    echo -e "Network:        $NET"
    echo -e "Uptime:         $UPTIME"
    echo
    get_top_processes
    echo "------------------------------------------"

    log_message "CPU: $CPU% | MEM: $MEM% | DISK: $DISK | TEMP: $TEMP | NET: $NET | BAT: $BATTERY | Up: $UPTIME"

    rotate_logs
    check_alerts

    sleep "$refresh_rate"
done

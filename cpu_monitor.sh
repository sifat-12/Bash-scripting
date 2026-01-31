#!/bin/bash
#
# cpu_monitor.sh
# Purpose : Log CPU usage and top CPU-consuming processes
# Author  : System Administration Team
#

# -----------------------------
# Configuration
# -----------------------------
LOG_DIR="/var/log/cpu_monitor"
LOG_FILE="${LOG_DIR}/cpu_usage.log"
CPU_THRESHOLD=80
TOP_PROCESSES=10

# -----------------------------
# Preparation
# -----------------------------
mkdir -p "$LOG_DIR" || exit 1
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# -----------------------------
# CPU Calculation
# -----------------------------
CPU_IDLE=$(top -bn1 | awk -F',' '/Cpu/ {print $4}' | awk '{print int($1)}')
CPU_USAGE=$((100 - CPU_IDLE))

# -----------------------------
# Logging
# -----------------------------
{
    echo "----------------------------------------"
    echo "Timestamp : $TIMESTAMP"
    echo "CPU Usage : ${CPU_USAGE}%"
    echo "Top ${TOP_PROCESSES} CPU-consuming processes:"
    ps aux --sort=-%cpu | head -n $((TOP_PROCESSES + 1))
} >> "$LOG_FILE"

# -----------------------------
# Alert Condition (Log only)
# -----------------------------
if [ "$CPU_USAGE" -ge "$CPU_THRESHOLD" ]; then
    echo "ALERT : CPU usage exceeded threshold (${CPU_USAGE}%)" >> "$LOG_FILE"
fi


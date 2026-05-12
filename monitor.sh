#!/bin/bash
LOG="/mnt/datos/logs/monitor.log"
FECHA=$(date +%Y%m%d_%H%M%S)
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}')
RAM=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2}')
DISCO=$(df -h /mnt/datos | awk 'NR==2{print $5}')
echo "[$FECHA] CPU: $CPU% | RAM: $RAM | DISCO: $DISCO" >> $LOG

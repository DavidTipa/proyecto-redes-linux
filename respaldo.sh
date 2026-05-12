#!/bin/bash
FECHA=$(date +%Y%m%d_%H%M%S)
DESTINO="/mnt/datos/backups"
LOG="/mnt/datos/logs/respaldo.log"
mkdir -p $DESTINO
mkdir -p /mnt/datos/logs
echo "[$FECHA] Iniciando respaldo total..." >> $LOG
tar -czf $DESTINO/backup_home_$FECHA.tar.gz /home 2>> $LOG
tar -czf $DESTINO/backup_etc_$FECHA.tar.gz /etc 2>> $LOG
echo "[$FECHA] Respaldo total completado." >> $LOG
touch /mnt/datos/backups/.ultimo_full
find $DESTINO -name "*.tar.gz" -mtime +7 -delete
echo "[$FECHA] Limpieza completada." >> $LOG

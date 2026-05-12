#!/bin/bash
FECHA=$(date +%Y%m%d_%H%M%S)
DESTINO="/mnt/datos/backups/incremental"
LOG="/mnt/datos/logs/respaldo.log"
MARCA="/mnt/datos/backups/.ultima_ejecucion"
mkdir -p $DESTINO
echo "[$FECHA] Iniciando respaldo incremental..." >> $LOG
if [ ! -f $MARCA ]; then
    touch -t 197001010000 $MARCA
fi
tar -czf $DESTINO/incremental_home_$FECHA.tar.gz --newer=$MARCA /home 2>> $LOG
tar -czf $DESTINO/incremental_etc_$FECHA.tar.gz --newer=$MARCA /etc 2>> $LOG
touch $MARCA
echo "[$FECHA] Respaldo incremental completado." >> $LOG

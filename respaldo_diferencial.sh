#!/bin/bash
FECHA=$(date +%Y%m%d_%H%M%S)
DESTINO="/mnt/datos/backups/diferencial"
LOG="/mnt/datos/logs/respaldo.log"
MARCA_FULL="/mnt/datos/backups/.ultimo_full"
mkdir -p $DESTINO
echo "[$FECHA] Iniciando respaldo diferencial..." >> $LOG
if [ ! -f $MARCA_FULL ]; then
    touch -t 197001010000 $MARCA_FULL
fi
tar -czf $DESTINO/diferencial_home_$FECHA.tar.gz --newer=$MARCA_FULL /home 2>> $LOG
tar -czf $DESTINO/diferencial_etc_$FECHA.tar.gz --newer=$MARCA_FULL /etc 2>> $LOG
echo "[$FECHA] Respaldo diferencial completado." >> $LOG

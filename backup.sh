#!/bin/bash

# Variáveis
DATE=$(date +%F)
LOG_FILE=/home/ubuntu/backup/backup.log
BACKUP_DIR=/home/ubuntu/backup
WEB_ROOT=/var/www
DB_NAME=eliezerdb

# Cria diretório de backup, se não existir
mkdir -p "$BACKUP_DIR"

# Backup dos arquivos do site
echo "[$(date)] Iniciando backup dos arquivos do site..." >> "$LOG_FILE"
if
        tar -czf "${BACKUP_DIR}/wordpress-files-${DATE}.tar.gz" -C "$WEB_ROOT" . 2>> "$LOG_FILE"
then
        echo OK >> "$LOG_FILE"
fi

# Backup do banco de dados
echo "[$(date)] Iniciando backup do banco de dados..." >> "$LOG_FILE"
if
        mysqldump --add-drop-database --add-drop-table --databases "$DB_NAME" > "${BACKUP_DIR}/wordpress-db-${DATE}.sql" 2>> "$LOG_FILE"
then
        echo OK >> "$LOG_FILE"
fi
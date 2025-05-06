#!/bin/bash

# Variáveis
DATE=$(date +%F)
LOG_FILE=/home/ubuntu/backup/backup.log
BACKUP_DIR=/home/ubuntu/backup
WEB_ROOT=/var/www
DB_NAME=eliezerdb
ERROR=0

# Prompt para a data do Backups
read -p "Digite a data do backup no formato YYYY-MM-DD (ex: 2025-05-15): " DATE_RESTORE

# Testes para validar a exitência dos Backups
if [ ! -f "${BACKUP_DIR}/wordpress-files-${DATE_RESTORE}.tar.gz" ]; then
    echo "Backup do Site não encontrado"
    ERROR=1
fi

if [ ! -f "${BACKUP_DIR}/wordpress-db-${DATE_RESTORE}.sql" ]; then
    echo "Backup do Banco de Dados não encontrado"
    ERROR=1
fi

if [ $ERROR -eq 1 ]; then
    exit 1
fi

# Backup dos arquivos do Site
echo "[$(date)] Iniciando Backup preventivo para o processo de Restore dos arquivos do Site..." >> "$LOG_FILE"
cp -r "${WEB_ROOT}/html" $BACKUP_DIR 2>> "$LOG_FILE"

if [ "$?" -ne 0 ]; then
    echo "Erro ao realizar Backup dos arquivos do Site"
    exit 1
else
    echo OK >> "$LOG_FILE"
fi

# Backup do banco de dados
echo "[$(date)] Iniciando Backup preventivo para o processo de Restore do Banco de Dados..." >> "$LOG_FILE"
mysqldump --add-drop-database --add-drop-table --databases "$DB_NAME" > "${BACKUP_DIR}/wordpress-db-$(date "+%FT%T").sql" 2>> "$LOG_FILE"

if [ "$?" -ne 0 ]; then
    echo "Erro ao realizar Backup do Banco de Dados"
    exit 1
else
    echo OK >> "$LOG_FILE"
fi

# Restauração dos arquivos do site
echo "[$(date)] Iniciando Restore dos arquivos do Site..." >> "$LOG_FILE"
if rm -rf "${WEB_ROOT}/html" 2>> "$LOG_FILE" && tar -xzf "${BACKUP_DIR}/wordpress-files-${DATE_RESTORE}.tar.gz" -C "$WEB_ROOT" 2>> "$LOG_FILE"; then
    echo OK >> "$LOG_FILE"
else
    echo "Erro ao realizar Restore dos arquivos do Site"
    exit 1
fi

# Restauração do banco de dados
echo "[$(date)] Iniciando Restore do Banco de Dados..." >> "$LOG_FILE"
if mysql "$DB_NAME" < "${BACKUP_DIR}/wordpress-db-${DATE_RESTORE}.sql" 2>> "$LOG_FILE"; then
    echo OK >> "$LOG_FILE"
else
    echo "Erro ao realizar Restore do Banco de Dados"
    exit 1
fi
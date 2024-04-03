#!/usr/bin/env bash

PROJECT_FOLDER=/root/real-salary
BACKUP_FOLDER=/root/backup/full_daily
BACKUP_TIME=$(date -Iseconds)

mkdir -p "${BACKUP_FOLDER}"
mkdir -p "${PROJECT_FOLDER}"

# find "${BACKUP_FOLDER}" -mmin +1440 -type f -exec nice -n 19 ionice -c2 -n7 rm -rf {} \; 

find "${BACKUP_FOLDER}" -mmin +60 -type f -exec nice -n 19 ionice -c2 -n7 rm -rf {} \;
nice -n 19 ionice -c2 -n7 tar -czf "${BACKUP_FOLDER}/file_backup_${BACKUP_TIME}.tar.gz" "${PROJECT_FOLDER}"

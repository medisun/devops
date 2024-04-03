#!/usr/bin/env bash

DB_SERVICE=statistics-db
PROJECT_FOLDER=/root/real-salary
BACKUP_FOLDER=/root/backup/db_30mins
DB_SHARED_FOLDER=/root/real-salary/database

mkdir -p "${BACKUP_FOLDER}"
mkdir -p "${PROJECT_FOLDER}"
mkdir -p "${DB_SHARED_FOLDER}"

find "${BACKUP_FOLDER}" -mmin +1440 -type f -exec nice -n 19 ionice -c2 -n7 rm -rf {} \;

cd "${PROJECT_FOLDER}"
/usr/bin/docker compose exec -T "${DB_SERVICE}" /bin/sh -c \
    'mysqldump -u root -p"${MYSQL_ROOT_PASSWORD}" --single-transaction --quick --lock-tables=false --all-databases | gzip > /database/dump-all-databases-$(date -Iseconds).sql.qz' 2> /dev/null
mv "${DB_SHARED_FOLDER}"/dump-all-databases-* "${BACKUP_FOLDER}"

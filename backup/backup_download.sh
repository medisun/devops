#!/usr/bin/env bash

SSH_KEY_PATH=/root/.ssh/id_rsa
REMOTE_IP=147.182.199.23
REMOTE_USER=root
REMOTE_BACKUP_FOLDER=/root/backup
LOCAL_BACKUP_FOLDER=/mnt/work/projects/snotor/real-salary/monitor_src/backup

mkdir -p "${LOCAL_BACKUP_FOLDER}"

LOCK_FILE=/tmp/_backup_sync.lock

# Avoid parallel syncronizations
if [ -f "$LOCK_FILE" ]; then
    echo "$LOCK_FILE exists. Copying is stoped";
    echo "Remove it manually to proceed."
    exit 1;
fi

touch "$LOCK_FILE"

nice -n 19 ionice -c2 -n7 find "${LOCAL_BACKUP_FOLDER}/full_daily/" -mtime +3 -type f -exec rm -rf {} \;
nice -n 19 ionice -c2 -n7 find "${LOCAL_BACKUP_FOLDER}/db_30mins/" -mmin +1440 -type f -exec rm -rf {} \;


nice -n 19 ionice -c2 -n7 rsync -tr -e "ssh -i ${SSH_KEY_PATH}" "${REMOTE_USER}@${REMOTE_IP}:${REMOTE_BACKUP_FOLDER}" "${LOCAL_BACKUP_FOLDER}"

rm "$LOCK_FILE"

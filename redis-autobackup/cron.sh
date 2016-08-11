#!/bin/bash

printenv | sed 's/^\(.*\)$/export \1/g' > /env_vars.sh

echo "${BACKUP_CRON:-0 13 * * *} root bash -c '. /env_vars.sh; /usr/local/bin/backup.sh &>> /var/log/cron'" > /etc/cron.d/backup

cron -f -L 15

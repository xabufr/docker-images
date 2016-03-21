#!/bin/sh
set -e
BASE=$0
BASE_PATH=$(dirname $BASE)

$BASE_PATH/backup-env.sh
if [ "$RESTORE" = "YES" ]; then
    $BASE_PATH/restore.sh
else
    $BASE_PATH/postgres.sh
fi

sudo -u postgres /usr/lib/postgresql/9.4/bin/postgres -D /var/lib/postgresql/9.4/main -c config_file=/etc/postgresql/9.4/main/postgresql.conf


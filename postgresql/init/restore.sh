#!/bin/bash
set -e

. /usr/share/postgresql-common/init.d-functions

create_socket_directory
mkdir -p /var/run/postgresql/9.4-main.pg_stat_tmp
chown postgres:postgres /var/run/postgresql/9.4-main.pg_stat_tmp

if [ "$POSTGRES_PASSWORD" ]; then
    authMethod=md5
else
    # The - option suppresses leading tabs but *not* spaces. :)
    cat >&2 <<-'EOWARN'
    ****************************************************
    WARNING: No password has been set for the database.
    This will allow anyone with access to the
    Postgres port to access your database. In
    Docker's default configuration, this is
    effectively any other container on the same
    system.
    Use "-e POSTGRES_PASSWORD=password" to set
    it in "docker run".
    ****************************************************
EOWARN
    authMethod=trust
fi

sudo -u postgres rm -rf /var/lib/postgresql/9.4/main
sudo -u postgres ./wal-e-wrapper.sh backup-fetch /var/lib/postgresql/9.4/main/ LATEST

LISTEN_ADDRESS='*' REMOTE_AUTH_METHOD="$authMethod" tiller -n -e prod
tiller -n -e recover

#!/bin/bash
set -e

PG_CTL="/usr/lib/postgresql/9.4/bin/pg_ctl"

mkdir -p "$PGDATA"
chmod 700 "$PGDATA"
chown -R postgres "$PGDATA"
mkdir -p /var/run/postgresql/9.4-main.pg_stat_tmp/
chown -R postgres /var/run/postgresql/9.4-main.pg_stat_tmp/

if [ ! -s "$PGDATA/PG_VERSION" ]; then
    sudo -u postgres /usr/lib/postgresql/9.4/bin/initdb -D "$PGDATA"

    # Use tiller to configure postgres locally only,
    AUTH=md5
    if [ "$POSTGRES_PASSWORD" ]; then
        pass="PASSWORD '$POSTGRES_PASSWORD'"
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
        pass=
        authMethod=trust
    fi

    LISTEN_ADDRESS="127.0.0.1" REMOTE_AUTH_METHOD="$authMethod" tiller -n -e prod

    # TODO Modifier pour bien contrôler le répertoire PGDATA
    sudo -u postgres "$PG_CTL" -D "$PGDATA" -w start


    : ${POSTGRES_USER:=postgres}
    : ${POSTGRES_DB:=$POSTGRES_USER}
    export POSTGRES_USER POSTGRES_DB

    if [ "$POSTGRES_DB" != 'postgres' ]; then
        sudo -u postgres psql <<-EOSQL
        CREATE DATABASE "$POSTGRES_DB" ;
EOSQL
        echo
    fi

    if [ "$POSTGRES_USER" = 'postgres' ]; then
        op='ALTER'
    else
        op='CREATE'
    fi

    sudo -u postgres psql <<-EOSQL
    $op USER "$POSTGRES_USER" WITH SUPERUSER $pass ;
EOSQL
    echo

    sudo -u postgres "$PG_CTL" -D "$PGDATA" -m fast -w stop

    LISTEN_ADDRESS="*" REMOTE_AUTH_METHOD="$authMethod" tiller -n -e prod
fi


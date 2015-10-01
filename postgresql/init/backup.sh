#!/bin/bash

ENV_PATH=/etc/wal-e.d/env/
mkdir -p $ENV_PATH

ENV=$(printenv)
while read line; do
    NAME=$(echo $line | awk -F "=" '{print $1}')
    VALUE=$(echo $line | awk -F "=" '{print $2}')
    echo $VALUE > "${ENV_PATH}${NAME}"
done <<< "$ENV"

curl --connect-timeout 1 http://169.254.169.254/latest/meta-data/ > dev/null

if [ $? -eq 0 ]; then
    touch /is_aws
fi


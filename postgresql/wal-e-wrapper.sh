#!/bin/sh

FLAGS=""

if [ -e /is_aws ]; then
    FLAGS=--aws-instance-profile
fi

exec envdir /etc/wal-e.d/env wal-e $FLAGS $@

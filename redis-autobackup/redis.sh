#!/bin/bash

set -e

printenv

/etc/redis.conf.sh

exec redis-server /etc/redis.conf

#!/bin/bash
set -e

nginx

/renew.sh

sleep infinity
# TODO Cron to auto renew

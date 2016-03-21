#!/bin/bash

/wal-e-wrapper.sh backup-push /var/lib/postgres/data/data
/wal-e-wrapper.sh delete --confirm retain 10

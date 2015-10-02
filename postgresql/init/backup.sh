#!/bin/bash

/wal-e-wrapper.sh backup-push /data/postgresql/9.4/main/
/wal-e-wrapper.sh delete --confirm retain 10

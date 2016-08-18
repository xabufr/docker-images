#!/bin/bash

BACKUP_FILE="/data/dump.rdb"

if [ -z "$S3_BACKUP_PATH" ]; then
	echo "S3 backup dir no specified, skipping..."
else
	today=$(date +%Y%m%d)
	if [ ! -f "$BACKUP_FILE" ]; then
		echo "Missing data for backup"
	else
		if [[ $S3_BACKUP_PATH != */ ]]; then
			$S3_BACKUP_PATH=$S3_BACKUP_PATH/
		fi
		echo "Starting uploading backup to S3"
		s3cmd --access_key=$ACCESS_KEY --secret_key=$SECRET_KEY put "$BACKUP_FILE" "$S3_BACKUP_PATH$today"
	fi
fi

# Allowed ENV parameters
 * `BACKUP_INTERVAL`, CRON interval for base backups
 * `RESTORE`, if set to YES, will try to recover DB from latest backup
 * `POSTGRES_PASSWORD`, the postgres password to set when init
 * `POSTGRES_DB`, the DB name to CREATE
 * ALL ENV VAR taken by WAL-E

# Goal
 * Base backup are done regularly by CRON task,
 * WAL file are uploaded on S3, and can be recovered to reply modifications on a BASE BACKUP

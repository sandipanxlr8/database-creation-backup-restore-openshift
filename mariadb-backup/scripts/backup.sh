#!/bin/bash

### User Pass Mysql ###
BACKUP_DIR="/opt/backup"
#BACKUP_DIR="/var/lib/mysql/backup"
BACKUP_DAILY=true # if set to false backup will not work
BACKUP_WEEKLY=true # if set to false backup will not work
BACKUP_MONTHLY=true # if set to false backup will not work
# BACKUP_RETENTION_DAILY=3
# BACKUP_RETENTION_WEEKLY=3
# BACKUP_RETENTION_MONTHLY=3

###Test daily weekly or monthly###
MONTH=`date +%d`
DAYWEEK=`date +%u`

if [[ ( $MONTH -eq 1 ) && ( $BACKUP_MONTHLY == true ) ]];
        then
        FN='monthly'
elif [[ ( $DAYWEEK -eq 7 ) && ( $BACKUP_WEEKLY == true ) ]];
        then
        FN='weekly'
elif [[ ( $DAYWEEK -lt 7 ) && ( $BACKUP_DAILY == true ) ]];
        then
        FN='daily'
fi


DATE=$FN-`date +"%Y%m%d"`

function local-backup
{
	mysqldump --max_allowed_packet=512M --skip-lock-tables --host=$DBHOST --port=3306 --all-databases --user=root --password=$DBPASSWORD  | gzip > $BACKUP_DIR/$DATE.sql.gz
	cd $BACKUP_DIR/
	ls -t | grep daily | sed -e 1,"$BACKUP_RETENTION_DAILY"d | xargs -d '\n' rm -R > /dev/null 2>&1
	ls -t | grep weekly | sed -e 1,"$BACKUP_RETENTION_WEEKLY"d | xargs -d '\n' rm -R > /dev/null 2>&1
	ls -t | grep monthly | sed -e 1,"$BACKUP_RETENTION_MONTHLY"d | xargs -d '\n' rm -R > /dev/null 2>&1

  ls -la $BACKUP_DIR
}

if [[ ( $BACKUP_DAILY == true ) && ( ! -z "$BACKUP_RETENTION_DAILY" ) && ( $BACKUP_RETENTION_DAILY -ne 0 ) && ( $FN == daily ) ]]; then
  local-backup
fi
if [[ ( $BACKUP_WEEKLY == true ) && ( ! -z "$BACKUP_RETENTION_WEEKLY" ) && ( $BACKUP_RETENTION_WEEKLY -ne 0 ) && ( $FN == weekly ) ]]; then
  local-backup
fi
if [[ ( $BACKUP_MONTHLY == true ) && ( ! -z "$BACKUP_RETENTION_MONTHLY" ) && ( $BACKUP_RETENTION_MONTHLY -ne 0 ) && ( $FN == monthly ) ]]; then
  local-backup
fi

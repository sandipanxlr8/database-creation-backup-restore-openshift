#!/bin/bash

### User Pass Mysql ###
BACKUP_DIR="/opt/backup"

function local-restore
{
	echo 'UNZIP FILE'
	cd $BACKUP_DIR/
	gunzip -c  $(ls daily*.gz -t -A | head -1) > mariadbrestore.sql
	ls -la .
  	echo 'START RESTORE'
	mysql --host=$DBHOST --port=3306 --user=root --password=$DBPASSWORD  < mariadbrestore.sql
	echo 'END RESTORE'
	rm mariadbrestore.sql
  	ls -la .
	echo 'DONE'
}

local-restore

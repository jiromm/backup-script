#!/bin/sh

BACKUP_FILES_DIR="/var/backup/files"
WWW_DIR="/var/www"

DBUSER="dumper"
DBPW="p@55vv0rd"

DATE=`date +%Y-%m-%d_%H-%M`
ISDB=0

SITES=(
  "site1"
  "site2|site2_db_name"
  "site3|site3_db_name"
  "site4"
)

for SITE in "${SITES[@]}"
do :
  echo "Processing $SITE"

  if echo $SITE | grep -q '|'; then
    DB=`echo $SITE | cut -d \| -f 2`
    SITE=`echo $SITE | cut -d \| -f 1`
    ISDB=1
  fi

  if [ ! -d "$BACKUP_FILES_DIR/$SITE" ]; then
    mkdir -p "$BACKUP_FILES_DIR/$SITE"
  fi

  if [ $ISDB = 1 ]; then
    mysqldump -u $DBUSER -p${DBPW} $DB > $BACKUP_FILES_DIR/$SITE/dbbackup_${DATE}.sql
  fi

  tar -zcf $BACKUP_FILES_DIR/$SITE/sitebackup_${DATE}.tar.gz $WWW_DIR/$SITE

  echo "Deleting old backups"

  find $BACKUP_FILES_DIR/$SITE/sitebackup* -mtime +5 -exec rm {} \;
  find $BACKUP_FILES_DIR/$SITE/dbbackup* -mtime +5 -exec rm {} \;
done

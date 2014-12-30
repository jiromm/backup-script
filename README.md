backup-script
=============

Simple script to backup web files and db

To execute every day via cron

1. Run this command
```
crontab -e
```

2. Add this line at the end of the file
```
1 1 * * * /bin/bash /var/backup/backup.sh
```

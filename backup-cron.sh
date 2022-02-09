#!/bin/bash

# The function supports the backup.sh scrypt by implementing backup with cron  

log()
{
    echo "$(date +"%d.%m.%Y %H:%M") $1" >> /home/backups/backup.log
}


backupcron()
{       
	dir_path=$(</home/backups/name.txt)
	dir_name=$(basename ${dir_path})
        date=$(date +%y%m%d-%H%M)
	file_name="${dir_name}-${date}.tar.gz"
	tar cfz ${file_name} ${dir_path}
        mv -f ${dir_name}-${date}.tar.gz /home/backups
	bytes=$(wc -c /home/backups/${file_name} | awk '{print $1}')
        log "Created: Option 2: A backup of directory ${dir_path} has been done on $(date +"%Y/%m/%d at %H:%M"). The file generated is ${file_name} and occupies ${bytes} bytes."
}
 
backupcron

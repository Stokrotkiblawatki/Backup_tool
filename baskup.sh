#!/bin/bash!

# The script is a backup tool with a simple user interface

log()
{
    echo "$(date +"%d.%m.%Y %H:%M") $1" >> /home/backups/backup.log
}

main()
{
while true
do
echo "\n"
echo "ASO 2021-2022
Wiktoria Szweda

Backup tool for directories
---------------------------

Menu
   1) Perform a backup
   2) Program a backup with cron
   3) Restore the content of a backup
   4) Exit

   Option:";
   
read menu_option;

case $menu_option in
        1)
                echo "Menu 1\nPath of the directory:"
                read dir_path
                echo "We will do a backup of the directory ${dir_path}."
		if [ ! -d "${dir_path}" ] 
		then
		      echo "The dirrectory does not exists!"
		      log "Error: Option 1: The directory ${dir_path} does not exist!"
	              continue
	        fi	      
		echo "Do you want to preceed (y/n)?"
		read decision
		if [ "${decision}" = "y" ] 
		then
	              if [ ! -d "/home/backups" ]
	              then
	                    mkdir /home/backups
	              fi
		      dir_name=$(basename ${dir_path})
		      date=$(date +%y%m%d-%H%M)
		      file_name="${dir_name}-${date}.tar.gz"		
		      tar cfz ${file_name} ${dir_path}
                      mv -f ${file_name} /home/backups
		      bytes=$(wc -c /home/backups/${file_name} | awk '{print $1}')
		      log "Created: Option 1: A backup of directory ${dir_path} has been done on $(date +"%Y/%m/%d at %H:%M"). The file generated is ${file_name} and occupies $bytes bytes."
		fi
		;;
	2)
		echo "Absolute path of the directory:"
		read dir_path
		begin=$(echo ${dir_path} | cut -b 1-2)
		if [ "${begin}" = "./" ]
		then
			echo "It is not an absolute path!"
                        log "Error: Option 2: The path ${dir_path} is not an absolute path!"
			continue
	        fi
		echo "Hour for the backup (0:00-23:59):"
		read hour
		echo "The backup will execute at ${hour}. Do you agree? (y/n)"
		read decision
                if [ "${decision}" = "y" ]
                then
		      if [ ! -d "/home/backups" ]
                      then
                            mkdir /home/backups
                      fi
                      if [ ! -f "/home/backups/backup.log" ]
                      then
                            touch /home/backups/backup.log
                      fi
		      h="$(echo "${hour}" | cut -d':' -f1)"
		      m="$(echo "${hour}" | cut -d':' -f2)"        
		      echo ${dir_path} > /home/backups/name.txt
		      cron_path=$(find /home -name backup-cron.sh)
		      chmod +x ${cron_path}
		      crontab -l > mycron
                      echo "$m $h * * * ${cron_path} >> /home/backups/backup.log 2>&1" >> mycron
                      crontab mycron
                      rm mycron
		fi
		;;
	3)
		echo "Menu 3"
		echo "The list of existing backups is:"
		ls -1 /home/backups | grep 'tar.gz' 
		echo "\n"
		echo "Which one do you want to recover:"
		read file_name
                if [ ! -f "/home/backups/${file_name}" ]
                then
                      echo "The file does not exist!"
                      log "Error: Option 3: The file ${file_name} does not exist!"
                      continue
                fi
                tar -xf /home/backups/${file_name}
		log "Extracted: Option 3: A backup ${file_name} has been extracted to the current directory (${PWD})"
                ;;
	4)
		exit 0
		;;
	esac
done;
}

main

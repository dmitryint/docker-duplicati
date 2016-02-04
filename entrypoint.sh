#!/bin/bash

PREFIX="duplicati"
for i in $@; do
	key="$i"
	if [ "${key:0:15}" = "--auth-username" ]; then
	 	BACKUP_S3_KEY="${key:16}"
	fi
	if [ "${key:0:8}" = "--prefix" ]; then
		PREFIX="${key:9}"
	fi
done	
if [ -z "$1" ]; then
    if [ ! -n "$DUPLICATI_PASS" ]; then
    	echo "ERROR- DUPLICATI_PASS must be defined"
    	exit 1
    fi
	exec mono /app/Duplicati.Server.exe --webservice-port=8200 --webservice-interface=* --webservice-password=${DUPLICATI_PASS}
elif [ "$1" = "backup" ]; then
	KEY=$(echo $@ | sed -r 's/[* ]\/[0-9a-zA-Z_].*+//' | sed '0,/backup/s/backup//')
	SERVER=$(echo $@ | sed -r 's/^[0-9a-zA-Z_].*:\/\/+//' | sed 's/?.*//' | sed 's/\/.*//') 
	if [ -n "$(find /root/.config/Duplicati/ -maxdepth 0 -empty)" ]; then
		FOLDER=empty
	else
		FOLDER=full
		if test -f $(cat /root/.config/Duplicati/dbconfig.json | jq -r --arg PREFIX $PREFIX --arg BACKUP_S3_KEY $BACKUP_S3_KEY --arg SERVER $SERVER '.[] | select (.Prefix==$PREFIX and .Username==$BACKUP_S3_KEY and .Server==$SERVER) | .Databasepath'); then
			CHECK=full
		else
			CHECK=empty
		fi
	fi	
	mono /app/Duplicati.CommandLine.exe find ${KEY} 
	if [ "$?" = "100" ]; then 
		REMOTE=empty
	else
		REMOTE=full
	fi
	if [ "${FOLDER}" = "empty" ] && [ "${REMOTE}" = "full" ] || [ "${FOLDER}" = "full" ] && [ "${CHECK}" = "full" ] && [ "${REMOTE}" = "full" ] || [ "${FOLDER}" = "full" ] && [ "${CHECK}" = "empty" ] && [ "${REMOTE}" = "full" ]; then
		mono /app/Duplicati.CommandLine.exe repair ${KEY}
	elif [ "${FOLDER}" = "full" ] && [ "${CHECK}" = "full" ] && [ "${REMOTE}" = "empty" ]; then
		echo "Unresolved situation"
		exit 101
	fi
	mono /app/Duplicati.CommandLine.exe $@
fi


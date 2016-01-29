#!/bin/bash
for i in $@; do
	key="$i"
	if [ "${key:0:15}" = "--auth-username" ]; then
	 	BACKUP_S3_KEY="${key:16}"
	elif [ "${key:0:15}" = "--auth-password" ]; then
	 	BACKUP_S3_SECRET="${key:16}"
	elif [ "${key:0:16}" = "--s3-server-name" ]; then
		SERVER="$key"
	elif [ "${key:0:12}" = "--passphrase" ]; then
		ENCRYPTION="$key"
	elif [ "${key:0:15}" = "--no-encryption" ]; then
		ENCRYPTION="$key"
	elif [ "${key:0:8}" = "--prefix" ]; then
		BUCKET="${key:9}"
	fi
done
	
if [ -z "$1" ]; then
    if [ ! -n "$DUPLICATI_PASS" ]; then
    	echo "ERROR- DUPLICATI_PASS must be defined"
    	exit 1
    fi
	exec mono /app/Duplicati.Server.exe --webservice-port=8200 --webservice-interface=* --webservice-password=${DUPLICATI_PASS}
elif [ "$1" = "backup" ]; then
	
	if [ -n "$(find /root/.config/Duplicati/ -maxdepth 0 -empty)" ]; then
		exec mono /app/Duplicati.CommandLine.exe repair --auth-username=${BACKUP_S3_KEY} --auth-password=${BACKUP_S3_SECRET} --prefix=${BUCKET} ${SERVER} ${ENCRYPTION} s3://$(echo ${BACKUP_S3_KEY}-${BUCKET}/v2 | tr '[:upper:]' '[:lower:]')/
	fi
fi
mono /app/Duplicati.CommandLine.exe $@

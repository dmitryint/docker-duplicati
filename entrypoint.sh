#!/bin/bash

echo $1
if [ -z "$1" ]; then
    if [ ! -n "$DUPLICATI_PASS" ]; then
      echo "ERROR- DUPLICATI_PASS must be defined"
      exit 1
    fi
	exec mono /app/Duplicati.Server.exe --webservice-port=8200 --webservice-interface=* --webservice-password=${DUPLICATI_PASS}
elif [ "$1" = "backup" ]; then
	if [ -n "$BACKUP_S3_PASSPHRASE" ]; then
		ENCRYPTION=--passphrase=${BACKUP_S3_PASSPHRASE}
	else 
		ENCRYPTION=--no-encryption
	fi
	if [ -n "$BACKUP_S3_SERVER" ]; then
		SERVER=--s3-server-name=${BACKUP_S3_SERVER}	
	fi
	exec mono /app/Duplicati.CommandLine.exe repair --auth-username=${BACKUP_S3_KEY} --auth-password=${BACKUP_S3_SECRET} --prefix=${BUCKET} ${SERVER} ${ENCRYPTION} s3://$(echo ${BACKUP_S3_KEY}-${BUCKET}/v2 | tr '[:upper:]' '[:lower:]')/
fi
mono /app/Duplicati.CommandLine.exe $@

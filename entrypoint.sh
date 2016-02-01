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
	if [ -n "mono /app/Duplicati.CommandLine.exe find --auth-username=${BACKUP_S3_KEY} --auth-password=${BACKUP_S3_SECRET} --prefix=${BUCKET} ${SERVER} ${ENCRYPTION} s3://$(echo ${BACKUP_S3_KEY}-${BUCKET}/v2 | tr '[:upper:]' '[:lower:]')/ | grep 'No filesets found on remote target'" ]; then 
		REMOTE=empty
	else
		REMOTE=full
		exec mono /app/Duplicati.CommandLine.exe repair --auth-username=${BACKUP_S3_KEY} --auth-password=${BACKUP_S3_SECRET} --prefix=${BUCKET} ${SERVER} ${ENCRYPTION} s3://$(echo ${BACKUP_S3_KEY}-${BUCKET}/v2 | tr '[:upper:]' '[:lower:]')/
		mono /app/Duplicati.CommandLine.exe $@
		exit 0
	fi
	if [ -n "$(find /root/.config/Duplicati/ -maxdepth 0 -empty)" ]; then
		FOLDER=empty
		mono /app/Duplicati.CommandLine.exe $@
		exit 0
	else
		FOLDER=full
		if [ -n "cat /root/.config/Duplicati/dbconfig.json | grep -A 5 '"Server": "s3://$(echo ${BACKUP_S3_KEY}-${BUCKET} | tr '[:upper:]' '[:lower:]')",' | grep -A 4 '"Path": "v2",' | grep -A 3 '"Prefix": "${BUCKET}",' | grep -A 2 '"Username": "${BACKUP_S3_KEY}",'" ]; then
			CHECK=full
			echo "Unresolved situation"
			exit 101
		else
			CHECK=empty
			if [ "$REMOTE" = "empty" ]; then
				mono /app/Duplicati.CommandLine.exe $@
				exit 0
			fi
		fi
	fi
echo "Undocumented error"
echo $CHECK
echo $REMOTE
echo $FOLDER
exit 102
fi


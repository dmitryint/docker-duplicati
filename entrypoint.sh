#!/bin/bash

DUPLICATI_CMD='mono /app/Duplicati.CommandLine.exe'

if [ -z "$1" ]; then
    if [ ! -n "$DUPLICATI_PASS" ]; then
      echo "ERROR- DUPLICATI_PASS must be defined"
      exit 1
    fi
	exec mono /app/Duplicati.Server.exe --webservice-port=8200 --webservice-interface=* --webservice-password=${DUPLICATI_PASS}
else
	$DUPLICATI_CMD $@
	if [ "$?" -eq 100 ] && [ -n "$ENABLE_AUTO_REPAIR" ]; then
		echo "Trying to repair local storage."
		$DUPLICATI_CMD $(echo $@ | sed "s/^\w*\s/repair /g" | sed -r 's/[* ]\/[a-zA-Z_].*+//')
		$DUPLICATI_CMD $@
	fi
fi
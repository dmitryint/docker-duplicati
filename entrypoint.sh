#!/bin/bash

DUPLICATI_CMD='mono /app/Duplicati.CommandLine.exe'

if [ -z "$1" ]; then
    if [ ! -n "$DUPLICATI_PASS" ]; then
      echo "ERROR- DUPLICATI_PASS must be defined"
      exit 1
    fi
	exec $DUPLICATI_CMD --webservice-port=8200 --webservice-interface=* --webservice-password=${DUPLICATI_PASS}
else
	$DUPLICATI_CMD $@
fi
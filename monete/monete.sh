#!/bin/bash

# Prueba de concepto, para script de monitorizacion sencillo


# 1.- lanza un comando, y guarda la salida
# 2.- compara esa salida con un archivo
# 3.- detecta si hay diferencias
# 4.- envia el email alertando (a. si es distinta de la salida anterior)


# Command to launch
COMMAND="ls -l"

# where is the working dir
WORK_DIR=/home/wakaru/src/github/minitools/monete/tmp/foo

# who wants to know about this?
EMAIL="wakaru44@gmail.com"

function launch 
{
	#bash $DEBUG $COMMAND > $WORKDIR/exec-$(date +%F).dat
	$COMMAND > $WORK_DIR/foo-$(date +%F).log
}

function differ
{
	diff -s $WORK_DIR/foo-$(date +%F).log $WORK_DIR/foo-base.log
}

function emailit
{
	# email subject
	SUBJECT="Something happend with your thingy"
	# Email text/message
	EMAILMESSAGE="$WORK_DIR/foo-$(date +%F).log"
	# send an email using systems mail command
	mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE

}

launch
if [ differ ]
then
	echo "difiere"
else
	echo "iguales"
fi
emailit




#!/bin/bash

# Prueba de concepto, para script de monitorizacion sencillo


# 1.- lanza un comando, y guarda la salida
# 2.- compara esa salida con un archivo
# 3.- detecta si hay diferencias
# 4.- envia el email alertando (a. si es distinta de la salida anterior)

##############################
#	Configuration
##############################

# Which command to launch?
# 	Try to get an output that will distinguish betwen
#	one situation that you want to be alerted for and
#	when you not
COMMAND="ls -l"

# where is the working dir located?
#	where the script will put all its working files and stamps.
# 	remember to give write permissions ;)
WORK_DIR=/home/wakaru/src/github/minitools/monete/tmp/foo

# who wants to know about this?
#	Email address to notify. 
#	Be sure to have enabled outgoing mail
# 	and mailutils installed
EMAIL="wakaru44@gmail.com"


##############################
#	The inner magic
##############################

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

function prepare_environment
{

	if [ -e $WORK_DIR ]
	then
		echo "directory exists"
	else
		echo "directory nonexistant"
		echo "Creating work directory:  $WORK_DIR"
		#TODO: ask for confirmation
		mkdir -p $WORK_DIR
	fi

}


##############################
#	Actual Script ;)
##############################

# check the working dir and so
prepare_environment
# launch a comand
launch
# test the output
if [ differ ]
then
	echo "difiere"
else
	echo "iguales"
fi
# and notify
emailit




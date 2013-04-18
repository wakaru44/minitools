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
WORK_DIR=/home/wakaru/src/minitools/monete/tmp/foo

# who wants to know about this?
#	Email address to notify. 
#	Be sure to have enabled outgoing mail
# 	and mailutils installed
EMAIL="wakaru44@gmail.com"


##############################
#	The inner magic
##############################

# where to log the scripts own activity
MONLOG=$WORK_DIR/monete.log
# The timestamp must be calculated once per launch
$TIMESTAMP=$(date +%F-%H-%M)

function launch 
{
	#bash $DEBUG $COMMAND > $WORKDIR/exec-$TIMESTAMP.dat
	$1 > $WORK_DIR/foo-$TIMESTAMP.log
}

function differ
{
	diff -s $WORK_DIR/foo-$TIMESTAMP.log $WORK_DIR/foo-base.log
}

function emailit
{
	# email subject
	SUBJECT="Something happend with your thingy"
	# Email text/message
	EMAILMESSAGE="$WORK_DIR/foo-$TIMESTAMP.log"
	# send an email using systems mail command
	mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE

}


function prepare_environment
{

	if [ -e $WORK_DIR ]
	then
		echo "Work directory: $WORK_DIR"
		echo "$TIMESTAMP - Work directory: $WORK_DIR" >> $MONLOG
	else
		echo "directory nonexistant"
		echo "$TIMESTAMP - directory nonexistant" >> $MONLOG
		# create the directory, asking for confirmation
		create_work_dir
	fi

	#TODO: check also log for existant base file
	#TODO: check also 

}


function create_work_dir
{

	echo "Do you wish to install this program?"
	select yn in "Yes" "No"; do
		case $yn in
			Yes ) make install;
			echo "Creating work directory:  $WORK_DIR"
			break;;
			No ) exit;;
		esac
	done
				[Yy]* ) echo "Creating work directory:  $WORK_DIR"
				echo "$TIMESTAMP - Creating work directory:  $WORK_DIR" >> $MONLOG
				#DEACTIVATED mkdir -p $WORK_DIR
				echo "fake create"
	
}
##############################
#	Actual Script ;)
##############################

# check the working dir and s
prepare_environment
# launch a comand
#DEACTIVATED launch $COMMAND
# test the output
if [ differ ]
then
	echo "$TIMESTAMP - Output changed. Sending email" >> $MONLOG
	# and notify
	#DEACTIVATED  emailit
else
	echo "$TIMESTAMP - Output hasn't changed, so doing nothing" >> $MONLOG
fi




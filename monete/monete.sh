#!/bin/bash

# Prueba de concepto, para script de monitorizacion sencillo


# 1.- lanza un comando, y guarda la salida
# 2.- compara esa salida con un archivo
# 3.- detecta si hay diferencias
# 4.- envia el email alertando (a. si es distinta de la salida anterior)
# ES_
# por ahora, compara la salida con un archivo base, y si difiere, envia un correo.
# hay que hacer que compare con la ULTIMA ejecucion, para el segundo modo de funcionamiento.

##############################
#	Configuration
##############################

# Which command to launch?
# 	Try to get an output that will distinguish betwen
#	one situation that you want to be alerted for and
#	when you not
COMMAND="ls -lR /servers/instaladoresrepo/backups/basesDeDatos/autobackups"

# where is the working dir located?
#	where the script will put all its working files and stamps.
# 	remember to give write permissions ;)
WORK_DIR=~/monitore

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
TIMESTAMP=$(date +%F-%H-%M)
# where is the script living?
RUN_DIR=$(dirname $0)

function check_runing_mode
{



if [ $1 ]
then

	if [ $1 == "test" ]
	then
		echo "Testing mode"
		WORK_DIR=$RUN_DIR/tests
		MONLOG=$WORK_DIR/monete.log

		# insert Test: TODO
		test_differ "$WORK_DIR"

		test_is_the_same "$WORK_DIR"

		test_emailit "$WORK_DIR"

		#TODO: test if the check of the command is done properly

		#TODO: check the process "monitor"

		exit
	else
		echo "Normal operation"
	fi

fi


}

function test_differ
{
	WORK_DIR=$1

	# 1.- que compare dos iguales y diga que iguales
	echo "Comparing two identical files"
	echo "$WORK_DIR/monete-command-igual.log" 
	echo "$WORK_DIR/monete-command-base.log"
	differ "$WORK_DIR/monete-command-igual.log" "$WORK_DIR/monete-command-base.log"
	echo $?

	# 2.- que comparre dos distintos y diga distintos
	echo "Compare different files should say they differ"
	echo "$WORK_DIR/monete-command-distinto.log" 
	echo "$WORK_DIR/monete-command-base.log"
	differ "$WORK_DIR/monete-command-distinto.log" "$WORK_DIR/monete-command-base.log"
	echo $?


}

function test_is_the_same
{
	WORK_DIR=$1
	# we need to check if this can take the decision when the output actually changed. HOW?
	# TODO

	echo "TODO"
}

function test_emailit
{
	WORK_DIR=$1
	echo "Testing Email sending with monete" > $WORK_DIR/deadletter
	echo "Monete is a simple monitoring tool" >> $WORK_DIR/deadletter
	EMAILMESSAGE="$WORK_DIR/deadletter"
	SUBJECT="Monete - Monitoring tool test"

	# send a test email
	echo "emailit should send a testing message"
	emailit "$SUBJECT" "$EMAILMESSAGE"

}

##############################

function launch 
{
	#bash $DEBUG $COMMAND > $WORKDIR/exec-$TIMESTAMP.dat
	"$@" > $WORK_DIR/monete-command-$TIMESTAMP.log
}


function differ 
{
	#diff -s $WORK_DIR/monete-command-$TIMESTAMP.log $WORK_DIR/monete-command-base.log
	#we can parametrize this! ;)
	echo "-----------------" >> $MONLOG
	diff -s $1 $2 >> $MONLOG
}


function is_the_same
{
	# A function to decide if we should warn or not
	differ $WORK_DIR/monete-command-$TIMESTAMP.log $WORK_DIR/monete-command-base.log
	if [ $? -eq 1  ]
	then
		echo "$TIMESTAMP - Output changed." 
		echo "$TIMESTAMP - Output changed." >> $MONLOG
		return 0
	else
		echo "$TIMESTAMP - Output hasn't changed, so doing nothing"
		echo "$TIMESTAMP - Output hasn't changed, so doing nothing" >> $MONLOG
		return 1
	fi
	#$WORK_DIR/monete-command-$TIMESTAMP.log $WORK_DIR/monete-command-base.log
	echo "foo"
}


function emailalert
{
	# email subject
	SUBJECT="Something happend with your thingy"
	# Email text/message
	EMAILMESSAGE="$WORK_DIR/monete-command-$TIMESTAMP.log"

	emailit "$SUBJECT" "$EMAILMESSAGE"
}


function emailit
{
	# receives $SUBJECT $EMAILMESSAGE
	# email subject
	SUBJECT=$1
	# Email text/message
	EMAILMESSAGE=$2
	# send an email using systems mail command
	echo "$SUBJECT"
	echo "$( cat $EMAILMESSAGE )"
	mail -s "$SUBJECT" "$EMAIL" < "$EMAILMESSAGE"
}


function prepare_environment
{
	#TODO:  check if the command exists
	#TODO:  check if there is a base.log file to compare to ( if not, diff asumes none)

	# check the work dir
	if [ -e $WORK_DIR ]
	then
		echo "Work directory: $WORK_DIR"
		echo "$TIMESTAMP - INFO - Work directory: $WORK_DIR" >> $MONLOG
	else
		echo "$TIMESTAMP - WARNING!! - directory nonexistant"
		# create the directory, asking for confirmation
		create_work_dir
	fi

	# check the lof file
	if [ -e $MONLOG ]
	then
		echo "Logging started" >> $MONLOG
	else
		touch $MONLOG
		echo "Starting logging" >> $MONLOG
		
	fi

	# check the base file
	if [ -e $MONLOG ]
	then
		echo "Base File Exists" >> $MONLOG
	else
		echo "$TIMESTAMP - WARNING!!! - No Base File exits" >> $MONLOG
		
	fi




}


function create_work_dir
{

	echo "The work directory does not exists. Create it?"
	echo " Or create a new dir in the users home?"
	echo " Pick a number"
	select yn in "Yes" "No" "Home"; do
		case $yn in
			Yes ) 
				echo "Creating work directory:  $WORK_DIR"
				echo "$TIMESTAMP - INFO - Creating work directory:  $WORK_DIR" >> $MONLOG
				mkdir -p $WORK_DIR
				echo "fake create"
				break;;
			Home ) 
				echo "Use the Home"
				# And we have to update all the location variables
				WORK_DIR=~
				MONLOG=$WORK_DIR/monete.log
				break;;
			No ) echo "Exiting. fix that and try again." ; exit;;
		esac
	done
}


##############################
#	Actual Script ;)
##############################

# We can run in "test" mode, or normal mode. 
#@ to use the test mode, launch the command "monete.sh test"
check_runing_mode  $1
# check the working dir and other stuf
prepare_environment
# launch the comand
launch $COMMAND
# test the output
is_the_same  
if [ $? -eq 1 ]
then
	echo "$TIMESTAMP - Sending email" >> $MONLOG
	# and notify
	emailalert
else
	echo "$TIMESTAMP - Checked" >> $MONLOG
fi




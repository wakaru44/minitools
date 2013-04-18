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
COMMAND="monitors/process.sh apache"
#TODO: check the execution dir, using basename

# where is the working dir located?
#	where the script will put all its working files and stamps.
# 	remember to give write permissions ;)
WORK_DIR=tmp

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


function check_runing_mode
{



if [ $1 ]
then

	if [ $1 == "test" ]
	then
		echo "Testing mode"
		WORK_DIR=tmp

		# insert Test: TODO
		test_differ

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

		# 1.- que compare dos iguales y diga que iguales
		echo "Comparing two identical files"
		differ $WORK_DIR/monete-command-igual.log $WORK_DIR/monete-command-base.log

		# 2.- que comparre dos distintos y diga distintos
		echo "Compare different files should show differences"
		differ $WORK_DIR/monete-command-distinto.log $WORK_DIR/monete-command-base.log


}

##############################

function launch 
{
	#bash $DEBUG $COMMAND > $WORKDIR/exec-$TIMESTAMP.dat
	$1 > $WORK_DIR/monete-command-$TIMESTAMP.log
}


function differ 
{
	#diff -s $WORK_DIR/monete-command-$TIMESTAMP.log $WORK_DIR/monete-command-base.log
	#we can parametrize this! ;)
	diff -s $1 $2
}


function is_the_same
{
	# A function to decide if we should warn or not
	differ $WORK_DIR/monete-command-$TIMESTAMP.log $WORK_DIR/monete-command-base.log
	if [ $? ]
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

function emailit
{
	# email subject
	SUBJECT="Something happend with your thingy"
	# Email text/message
	EMAILMESSAGE="$WORK_DIR/monete-command-$TIMESTAMP.log"
	# send an email using systems mail command
	mail -s "$SUBJECT" "$EMAIL" < $EMAILMESSAGE

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
if [ ! $? ]
then
	echo "$TIMESTAMP - Sending email" >> $MONLOG
	# and notify
	emailit
else
	echo "$TIMESTAMP - Checked" >> $MONLOG
fi




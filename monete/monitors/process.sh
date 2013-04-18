#!/bin/bash

USAGE="This little script checks if a process is running.
	Usage:
		
		$0 processname

	It works pretty much like pgrep ;)"

if [ $1 ]
then
	#check that the process is running 
	pgrep $1 >/dev/null
	if [ $? -eq 0 ]
	then
		echo "$1 OK"
	else
		echo "$1 Jodido"
	fi
else
	# show usage and exit with error
	echo "$USAGE"
	exit 1
fi


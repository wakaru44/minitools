#!/bin/bash
pgrep $1
if [ $? -eq 0 ]
then
	echo "$1 OK"
else
	echo "$1 Jodido"

fi

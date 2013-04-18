#!/bin/bash
if [ pgrep $1 ]
then
	echo "Apache OK"
else
	echo "Apache Jodido"

fi

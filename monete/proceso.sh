#!/bin/bash
if [ pgrep $1 ]
then
	echo "Apache rulando"
else
	echo "Apache pocho"
fi

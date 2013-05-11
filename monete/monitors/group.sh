#!/bin/bash

#This is a test to group different checks in one file
# Just write all the checks in secuence and enjoy ;)

echo "Im running on" $(dirname $0) "Directory"

echo "Checking mosh sessions"
monitors/mosh-sessions.sh
echo "Checking whether is apache running or not"
monitors/process.sh apache



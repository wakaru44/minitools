#!/bin/bash
# Display the user and port of all the mosh sessions opened in this server
# Must be run as root, or it will only find out the runing user sessions

PS=$(ps -ef)
echo "$PS" | awk '/mosh/ && !/'$0'/ { print "Esta " $1 " En el puerto " $12 }'


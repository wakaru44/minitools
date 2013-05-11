# Monete - Monitorig Tool

## What's this shit nigga?

"Nagios is a chainsaw. This is a scalpel"

Monete is a little script, that you can configure in your crontab.

You configure it to run every X minutes, or when you want.
It will _execute_ the configured command, _compare the output_ to the output obtained in the "right" execution, _and send an email_ if they are different.

This means, that you can **monitor any change in your system**.


## Usage

	1.- Put it in a dir 
		like /usr/bin or /etc/cron.d
	2.- Choose a working dir
		like /usr/local/monete
	3.- Configure your crontab
		like to execute every five minutes
	5.- Configure your options in monete.sh
		You should change the EMAILADDRESS and the WORK_DIR
	6.- Configure your command to launch
		like "monitors/process.sh apache"
	7.- Save a base file, so we can check against it
		like "monete-command-base.log"
	8.- Your good to go

## Monitors

We, have also created a few helping scripts called "monitors" that will help you use Monete with ease, and get ready in a minute.

If you need more documentation about a "monitor", check the file of it. Usually you call them with some param, and they handle the output.





## Branches

### Concomandos
this development branch was created to write the code to support commands in the form of small scripts, that can build more complex commands, with simplified output, parseable by the monete.sh.



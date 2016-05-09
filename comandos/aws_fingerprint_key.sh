#!/bin/bash

key=$1

openssl pkcs8 -in $key -nocrypt -topk8 -outform DER | openssl sha1 -c

#!/bin/bash

for palabra in $(cat palabras.list); do
	./phonen2.py $palabra  >> phonemes.list


done

#!/usr/bin/python

""" Script que recibe una palabra como parametro, y busca sus sinonimos en
www.sinonimos.org, mostrandolos por pantalla"""

import sys
import urllib2
from bs4 import BeautifulSoup


def usage():
    """muestra la ayuda"""
    print "To look up for a sinonim:"
    print "\t sinon2.py <word>"
    print "And it will find words with the same meaning of <word>"
    return 0


## Recogemos el parametro de entrada
if (len(sys.argv) < 2 or len(sys.argv) > 2):
    usage()
    sys.exit(1)
else:
    palabra = sys.argv[1]


## Escapamos lapalabra y creamos la URL
palabra = palabra.lower()
url = "http://www.sinonimos.org/" + palabra
#print url

## Descargamos la web con urllib2
web = urllib2.urlopen(url)
content = web.read()
#print content


## parseamos el html, y extraemos la lista de sinonimos
soup = BeautifulSoup(content)
terminos = soup.find_all("b")
sinonimos = []
for termino in terminos:
    sinonimo = termino.contents

    if u'profesor particular' not in sinonimo[0] and u'diccionario de sinonimos'not in sinonimo[0]:
        sinonimos.append(sinonimo[0])


## imprimimos en pantalla lo mas frugalmente posible
for sinonimo in sinonimos:
    print sinonimo


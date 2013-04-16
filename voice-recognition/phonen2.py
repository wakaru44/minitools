#!/usr/bin/python

""" Script que recibe una palabra como parametro, y busca sus sinonimos en
www.sinonimos.org, mostrandolos por pantalla"""

import sys
import urllib2
from bs4 import BeautifulSoup

def fonetizar(palabra):
    palabra = palabra.lower()
    url = "http://es.thefreedictionary.com/" + palabra 
    web = urllib2.urlopen(url)
    content = web.read()

    soup = BeautifulSoup(content)
    terminos = soup.find_all("span", {"class":"pronOx"})
    fonemadas = []
    for termino in terminos:
        fonemada = termino.contents
        fonemadas.append(fonemada[0])

    for fonema in fonemadas:
        print palabra, "   :   ",fonema


def main():
    fh = open("palabras.list", "r")
    lista_origen = fh.readlines()
    for palabra in lista_origen:
        palabra = palabra.strip()
        fonetizar(palabra)

    fh.close()

if __name__ == "__main__":
    main()



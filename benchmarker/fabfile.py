#!/usr/bin/python
# -*- coding: utf-8 -*-
# Script conejo para evitar el rollo de las pruebas
# ¿Que es tan rollo?
# 1.- el tener que dar un nombre diferente a cada puto archivo
# 2.- el tener que asociar unos parametros de lanzamiento a una prueba y unos
# resultados
# 3.- tener que lanzar varios procesos a la vez, unos para monitorizar, y otros
# las pruebas en si

# 

import os

from fabric.api import *
from fabric import contrib
from fabtools import *

env.hosts = ["wakaru@localhost"]

#TODO: definir roles para los hosts

class BaseClass(object):
    """ES_ base tipo"""

    base_dir = "~/benchmarking"
    bench_name = "pruebas01"  # name for the bench/project

    def __init__(self):
        #- ES_ preparamos una carpeta de trabajo
        self.work_dir = os.path.join(self.base_dir, self.bench_name)



    #TODO: definir el rol de este metodo para la maq de pruebas
    def preparar(self):
        """ES_ wrapper para preparar el entorno"""
        if not contrib.files.exists(self.work_dir):
            #- ask the user
            print("ES_ El directorio de trabajo no existe")
            print self.work_dir
            if contrib.console.confirm("ES_ Crear el directorio?"):
                #- crear el directorio
                run("mkdir -p {0}".format(self.work_dir))
            else:
                #- morir
                abort("ES_ no hay directorio de trabajo")


    def save_log(self, thingtolog, logfile="command.log" ):
        """guarda algo en el log"""
        logpath = os.path.join(self.work_dir, logfile)
        log_algo(logpath, thingtolog)



            


class PruebaClass(BaseClass):
    """clase base de pruebas."""

    commands = []

    #TODO: definir el rol de este metodo a local/bench
    def lanzar(self):
        """tira la prueba en si"""
        for command in self.commands:
            print "lanzando:"
            print command
            try:
                result = run(command)
                self.save_log(result)
            except Exception as e:
                print "shit happends"
                print result
                self.save_log(result)

    def parar(self):
        """acciones necesarias para parar la prueba"""
        pass

    def addCommand(self, command):
        """agrega un comando a la prueba"""
        self.commands.append(command)


class MonitorClass(BaseClass):
    """clase para controlar las herramientas de monitorizacion"""

    def lanzar(self):
        """arranca las herramientas de monito"""
        pass


class dstat(MonitorClass):
    """ controla dstat """

    logfile = "dstat.log"  # el archivo que guardara en remoto
    pid = 0  # guarda el pid del dstat

    def lanzar(self):
        """lo arranca y guarda el log ¿y un pid?"""
        #run("dtach -n `mktemp -u /tmp/{logf} dstat") # needs install
        result = run("nohup dstat > /tmp/{logfile} &".format(logfile=self.logfile))
        print result



    def getLog(self):
        """recoge el archivo y lo trae a local"""
        pass  #TODO

    def stopMonitor(self):
        """stop the monitor command"""
        pass #TODO: find a way to kill it
        #run("pkill dstat")

    def parar(self):
        """se encarga de parar el dstat, y recoger el log"""
        self.stopMonitor()
        self.getLog(self.logfile)




##############################
##############################

def definir_prueba():
    """ definir los parametros a usar"""
    #- como una lista de parametros ¿Dic?
    params = []
    #- por ahora, unaprueba a cambiar el num de conexiones de un httperf
    p1={"cons": 10}
    p2={"cons": 5}
    params = [p1, p2]


    return params


def preparar_monitores():
    """ se encarga de tirar las herramientas de monitorizacion"""
    tool1="dstat"
    #TODO: hacer que lance esta mierda contra un log en el workdir
    monito1 = dstat()
    monito1.lanzar()
    try:
        run("ps -ef | grep -v grep | grep dstat")
    except:
        pass
    monito1.stopMonitor()


def lanzar_prueba(prueba, params=None):
    """tira una prueba con los parametros recibidos"""
    #TODO: delete
    params = {"server": "tri.poli.nom.es",
              "cons": 5
             }
    command = """httperf --hog --server={server} --wsess={cons},2,2 --rate=1 --timeout 5""".format(**params)
    prueba.addCommand("""httperf --hog --server={server} --wsess={cons},2,2 --rate=1 --timeout 5""".format(**params))
    print "prueba a lanzar"
    print(command)
    prueba.lanzar()
    return 0


def log_algo(archivo = "~/benchmarking/pruebas01/command.log",
             thingtolog = "Estas intentando loguear algo..."
            ):
    if contrib.files.exists(archivo):
        contrib.files.append(archivo, thingtolog)
    else:
        raise Exception("Joder, no hay directorio")

def lanzar_todo():
    prueba = PruebaClass()
    params = definir_prueba()
    prueba.preparar()  # prepara el entorno. molan mas los metodos de este estilo


    preparar_monitores()
    lanzar_prueba(prueba, params) # lanzarlo asi
                    # quiza es un poco lioso. mejor
                    # agruparlo todo en el metodo como dios manda.





"""##############################

ALgo de documentacion:

    para usar esta mierda, se supone que solo debemos redefinir los diccionarios
    con los parametros de cada prueba, y luego el lanzara una prueba por cada
    diccionario de parametros en la lista.

    Para usar otros comandos, hay que usar otros diccionarios. no se si seria
    interesante trabajar esa parte.
    Para cambiar mas parametros del httperf, hay que redefinir la cadena que se
    pasa y agregar sustituciones.

    #TODOS:
        - que guarde cada ejecucion en una carpeta si hay mas de una prueba que
        lanzar
        - que lanze monitorizacion mientras, y guarde la monitorizacion en el
        mismo archivo de las otras pruebas
        QUESTION: que preferimos, que lance un monitor por cada comando que
        lanza, o que guarde toda la monitorizacion de una prueba en la misma
        carpeta???


"""

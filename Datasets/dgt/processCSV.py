# -*- coding: utf-8 -*-
import os
import sys
import re

#IMPORTANT: TO BE TESTED YET!

fileName = sys.argv[1]
with open(fileName, "r") as fp : lines = fp.readlines()
i=0
estacion = ""
calzada = ""
carriles = ""
poblacion = ""
carretera = ""
PK = ""
provincia = ""
tipo = re.search('H(.*).csv',fileName).group(1).replace(";","").replace(" ","")
while(i < len(lines)) :
	#;;;;;;;Estación:;CO-5-5 Calzada:;;Total;;Carriles:;;2+2;Prov:;CO
	#;;;;;;;Población:;CUESTA DEL ESPINO;;;;;Carretera:;;A-4;PK:;414,16
	#print lines[i]
	if "Estaci" in lines[i]:
		estacion = re.search('Estación:(.*)Calzada',lines[i]).group(1).replace(";","").replace(" ","")
		calzada = re.search('Calzada:(.*)Carril',lines[i]).group(1).replace(";","").replace(" ","")
		carriles = re.search('Carriles:(.*)Prov',lines[i]).group(1).replace(";","").replace(" ","")
		provincia = re.search('Prov:(.*)\n',lines[i]).group(1).replace(";","").replace(" ","")
	if "Poblaci" in lines[i]:
		poblacion = re.search('Población:(.*)Carretera',lines[i]).group(1).replace(";","")
		carretera = re.search('Carretera:(.*)PK',lines[i]).group(1).replace(";","").replace(" ","")
		PK = re.search('PK:(.*)\n',lines[i]).group(1).replace(";","").replace(" ","")
	splitted = re.split(';| |\t',lines[i])
	if splitted[0].startswith("1") or splitted[0].startswith("2"):
		print tipo+";"+estacion+";"+calzada+";"+carriles+";"+provincia+";"+poblacion+";"+carretera+";"+PK+";"+splitted[0]+";"+splitted[1]+";"+splitted[2]+";"+splitted[3]+";"+splitted[4]+";"+splitted[5]+";"+splitted[6]+";"+splitted[14]
	i=i+1
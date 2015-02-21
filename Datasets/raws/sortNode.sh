#!/bin/bash

cat $1 | tr " " "_" | tr "," " " > datos.dat

for i in `cat datos.dat | grep -v "idNodo" | awk '{print $1}'`
    do
    fn=$i".csv"
    if [ ! -f $fn ]; then
        echo "idNodo,idDispositivo,tfin tinicio,tdiferencia,latitud,longitud,majordeviceclass,minordeviceclass,serviceclass,fabricante" > $fn
        cat datos.dat | grep $i | tr " " "," | tr "_" " " >> $fn
    fi
done
rm datos.dat
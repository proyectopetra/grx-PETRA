#!/bin/bash

for file in `ls *.csv`; do
salida=`echo $file | tr "." " " | awk '{print $1}'`
cat $file | tr " " "_" | tr "," " "|grep -v idNodo | awk '{print $5}' > $salida.t

done
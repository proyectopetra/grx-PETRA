#!/bin/bash

mkdir tempCSV

for file in HPeajes.csv  HPermanentes.csv  HPrimarias.csv  HSecundarias.csv  HSemipermanentes.csv; do
    echo "## Procesando $file ..."
    cat $file | awk '/EVOLUCIÓN HISTÓRICA DE UNA ESTACIÓN/{n++}{print > "partial" n ".tmp" }'
    mv *.tmp tempCSV
    cd tempCSV
    for mini in `ls *.tmp`; do
        #echo %%% El archivo reducido con el que trabaja ahora es $mini
        estacion=`cat $mini |  grep Estación | tr ";" " " | awk '{print $2'}`
        calzada=`cat $mini | grep Estación | tr ";" " " | awk '{print $4'}`
        carriles=`cat $mini | grep Estación |tr ";" " " | awk '{print $6'}`
        prov=`cat $mini | grep Estación | tr ";" " " | awk '{print $8'}`
        poblacion=`cat $mini | grep Población | tr " " "_" | tr ";" " " | grep -Po '(?<=(Población: )).*(?= Carretera:)'`
        carretera=`cat $mini | grep Población | tr " " "_" | tr ";" " " | grep -Po '(?<=(Carretera: )).*(?= PK:)'`
        pk=`cat $mini | grep Población | tr " " "_" | tr ";" " " | grep -Po '(?<=(PK: )).*(?=)'`
        denantigua=`cat $mini | grep "Denominación antigua" | tr " " "_" | tr ";" " " | awk '{print $3}'`
        cat $mini | grep -v ";;;" | grep -v "Total"| sed -e "s/$/$estacion;$calzada;$carriles;$prov;$poblacion;$carretera;$pk;$denantigua/"|tr -d " " | tr "_" " " > $mini'b'
    done
    cat *.tmpb >> $file'.new'
    rm *.tmp *.tmpb
    cd ..
done

echo "Año;Total;Moto;Lige;Bus;Camión;Pesa;Pesa;Total;Moto;Lige;Bus;Camión;Pesa;Días;%;Ant;Comarac;Estacion;Calzada;Carriles;Prov;Poblacion;Carretera;Pk;Denantigua" > Complete.csv
cat tempCSV/*.new >> Complete.csv
rm tempCSV/*.new
rmdir tempCSV
echo " "
echo "## Procesamiento completado."
echo " "
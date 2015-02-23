#!/bin/bash
cat all-without-0-data-years.csv | tr " " "_" | tr ";" " " | awk '{print $0 ";" $6 "_" $7 "_km_" $8}'| tr " " ";" | tr "_" " " > optimusData.csv
## What is the content of files here

* dgt/concat_all.csv

A 'csv' with all the 'dgt/H*.csv' files under the same directory. Made with 'concat.js'. If you have [node](http://nodejs.org) installed, first do `npm install` and then 'node concat.js' to generate a new file out of the 'dgt/H*.csv' ones.

* dgt/all.csv

A 'csv' that contains all data.

* dgt/all-without-0-data-years.csv

A 'csv' that contains all data cleaned of meaningless data.

* dgt/optimusData.csv

A 'csv' that contains all data cleaned and ready to use on Google Fusiontables

* dgt/HPeajes.csv  
* dgt/HPermanentes.csv  
* dgt/HPrimarias.csv  
* dgt/HSecundarias.csv  
* dgt/HSemipermanentes.csv

All this csv files were obtained from pdf files avaible on sl.ugr.es/pdfs_dgt

* dgt/joinSources.sh
* dgt/processCSV.py

A BASH script and a Python script to join HPeajes.csv, HPermanentes.csv,  HPrimarias.csv,  HSecundarias.csv and  HSemipermanentes.csv as a single csv file with added info from each table as column data.

* dgt/prepare2google.sh

A BASH script to convert dgt/all-without-0-data-years.csv to dgt/optimusData.csv
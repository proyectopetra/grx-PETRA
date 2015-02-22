var fs = require('fs');
var rm = require('rimraf');
var through = require('through');
var readline = require('readline');

var outputFile = 'dgt/concat_all.csv';
rm.sync(outputFile); // remove file if was there

var outputStream = fs.createWriteStream(outputFile);

// read that dirr
fs.readdir('dgt', function(err, dirls){
  if(err){ throw err; }
  dirls.forEach(function(inputFile){
    if((/H*.csv$/i).test(inputFile)){
      var label = inputFile.substring(1).replace('.csv', '');
      cleanUp(inputFile, label);
    }
  });
});

// add more stuff here if you wish


function cleanUp(inputFile, label){

  var reader = readline.createInterface({
    input: fs.createReadStream('dgt/'+inputFile),
    output: through()
  });

  var meta = '', match = '';
  reader.on('line', function(line){

    var num = line.match(/^\d+/);

    if(!num){

      if(match && (/Pesa/).test(match)){
        meta = '';
      }

      if((match = line.match(/Estación:(.*)/))){
        meta += match[1].replace(/Calzada|Carriles|Prov/g, ';');
      } else if((match = line.match(/Población(.*)/))){
        meta += match[1].replace(/Carretera|PK/g, ';');
      } else if((match = line.match(/Denominación antingua(.*)/))){
        meta += match[1];
      } else { match = line; }

      if(match){
        meta = meta.trim()
          .replace('\.', ' ')
          .replace(/[:;]+/g, ';')
          .replace(/(?:[ ]+)?(\d+)(?:[ ]+)?/g, '$1');
      }

    } else {

      line = line.replace(/[ ]+/g, ';');
      outputStream.write(
        (label + meta + ';' + line).trim().replace(/[,]/g, '.') + '\n'
      );
    }

  });
}

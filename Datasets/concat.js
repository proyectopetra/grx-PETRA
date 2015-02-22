var fs = require('fs');
var rm = require('rimraf');
var through = require('through');
var readline = require('readline');

var outputFile = 'dgt/concat_all.csv';
rm.sync(outputFile); // remove file if was there

var outStream = fs.createWriteStream(outputFile);

// read that dirr
fs.readdir('dgt', function(err, dirls){
  if(err){ throw err; }
  dirls.forEach(function(inputFile){
    if(inputFile.match(/H.*csv$/)){
      var label = inputFile.substring(1)
        .replace('.csv', '').toLowerCase();
      cleanUp(inputFile, label);
    }
  });
});

// add more stuff here if you wish
var sanityMap = {
  'á': 'a',
  'é': 'e',
  'í': 'i',
  'ó': 'o',
  'ú': 'u',
  'ü': 'u',
 ':;': '',
 'poblacion:;;': 'poblacion'
};

function cleanUp(inputFile, label){
  var reader = readline.createInterface({
    input: fs.createReadStream('dgt/'+inputFile),
    output: through()
  });

  reader.on('line', function(line){
    var saneRE = new RegExp(
      Object.keys(sanityMap).join('|'), 'ig'
    );

    var num = line.match(/^\d+/);
    if(num && line.match(/[ ]+/)){
      // replace space(s) ocurrence(s) with ';'
      line = line.trim().replace(/[ ]+/g, ';');
    }

    // ok, normalize this thing
    line = line.toLowerCase()
      .replace(saneRE, function($0){
        return sanityMap[$0] || $0;
      });

    outStream.write(label + ';' + line + '\n');
  });
}

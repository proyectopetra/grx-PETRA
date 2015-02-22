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
  'ü': 'u'
};

var saneRE = new RegExp(
  Object.keys(sanityMap).join('|'), 'ig'
);

var replaceMap = {
  ':': '',
  'poblacion:;;': 'poblacion;',
  'poblacion:;': 'poblacion',
  'estacion;': '',
  'poblacion;' : '',
};

var replaceKeys = Object.keys(replaceMap);

function cleanUp(inputFile, label){
  var reader = readline.createInterface({
    input: fs.createReadStream('dgt/'+inputFile),
    output: through()
  });

  reader.on('line', function(line){
    var num = line.match(/^\d+/);
    if(num && line.match(/[ ]+/)){
      // replace space(s) ocurrence(s) with ';'
      line = line.trim().replace(/[ ]+/g, ';');
    }

    // ok, normalize this thing
    line = line.replace(saneRE, function($0){
        return sanityMap[$0] || $0;
      }).toLowerCase();

    replaceKeys.forEach(function(key){
      line = line.replace(key, replaceMap[key]);
    });

    outStream.write(label + ';' + line + '\n');
  });
}

var fs = require('fs');
var through = require('through');
var readline = require('readline');
var outputFile = fs.createWriteStream('dgt/allConcatjs.csv');

fs.readdir('dgt', function(err, dirls){
  if(err){ throw err; }
  dirls.forEach(function(inputFile){
    if(inputFile.match(/csv$/)){
      cleanUp(inputFile);
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

function cleanUp(inputFile){
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

    var label = inputFile.substring(1)
      .replace('.csv', '').toLowerCase();

    outputFile.write(label + ';' + line + '\n');
  });
}

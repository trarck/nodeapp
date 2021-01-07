var fs=require('fs');
var path=require('path');
var yhnode=require("yhnode");

var ArgParser=yhnode.base.ArgParser;
var mkdirs=yhnode.filesystem.Path.mkdirs;
var Task=yhnode.async.Task;
var WorkPool=yhnode.async.WorkPool;

var IndexFile=require("./IndexFile.js").IndexFile;
var Csv=require("./Csv.js");


var opts= [
   { 
	   full: 'src', 
	   abbr: 's',
	   defaultValue:""
   }, 
   { 
	   full: 'out', 
	   abbr: 'o',
	   defaultValue:""
   }
];

var result=ArgParser.parse(opts);

var srcPath=result.options.src || "data";
var outPath=result.options.out || "out";
var action = result.cmds[0];
mkdirs(outPath);

var idxGroup = IndexFile.getIdxFiles(srcPath);
for(var i in idxGroup){
    IndexFile.loadAllIdxVersionEntries(idxGroup[i])
}

var sameVersionIdxs=[];
var version=1;
for(var i in idxGroup){
    var idxs=idxGroup[i];
    sameVersionIdxs.push(idxs[version-1]);
}
console.log(sameVersionIdxs.length);

var sameVersionEntries=[];
for(var i in sameVersionIdxs){
    sameVersionEntries=sameVersionEntries.concat(sameVersionIdxs[i].entries);
    console.log(sameVersionEntries.length,sameVersionIdxs[i].entries.length);
}

sameVersionEntries.sort(IndexFile.sortIdxEntries);
var versionPath=path.join(outPath,version+".csv");
Csv.writeAll(versionPath,sameVersionEntries);

function outCsvData(filePath,arr){
    console.log("export",filePath);
    var cnt="";
    for(var i in arr){
        for(var k in arr[i]){
            cnt+=arr[i][k]+","
        }
        cnt+="\n";
    }
    fs.writeFileSync(filePath,cnt);
}

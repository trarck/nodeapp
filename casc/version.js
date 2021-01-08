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
   }, 
   { 
	   full: 'startVersion', 
	   abbr: 'sv',
	   defaultValue:1
   }, 
   { 
	   full: 'endVersion', 
	   abbr: 'ev',
	   defaultValue:null
   }
];

var result=ArgParser.parse(opts);

var srcPath=result.options.src || "data";
var outPath=result.options.out || "out";
var startVersion=result.options.startVersion || 1;

mkdirs(outPath);

var idxGroup = IndexFile.getIdxFiles(srcPath);
for(var i in idxGroup){
    idxGroup[i].sort(IndexFile.sortIdxByVersionAsc);
    IndexFile.loadAllIdxVersionEntries(idxGroup[i])
}

var maxVersion=0;

for(var i in idxGroup){
    var idxs=idxGroup[i];
    if(idxs.length>maxVersion){
        maxVersion=idxs.length;
    }
}
console.log("maxVersion=",maxVersion);

var endVersion=result.options.endVersion || maxVersion;
exportVersionData(startVersion,endVersion);

function exportVersionData(startVersion,endVersion){
    for(var i=startVersion;i<endVersion;++i){
        var sameVersionIdxs=getVersionIdxs(i,idxGroup);
        exportVersionEntries(i,sameVersionIdxs);
    }
}


function exportVersionEntries(version,idxs){
    console.log("export version "+version+" entries");
    var sameVersionEntries=[];
    for(var i in idxs){
        sameVersionEntries=sameVersionEntries.concat(idxs[i].entries);
    } 
    
    sameVersionEntries.sort(IndexFile.sortIdxEntries);
    var versionPath=path.join(outPath,version+".csv");
    Csv.writeAll(versionPath,sameVersionEntries);
}

function getVersionIdxs(version,idxGroup){
    console.log("collect version "+version+" idx");
    var sameVersionIdxs=[];
    for(var i in idxGroup){
        var idxs=idxGroup[i];
        if(version>idxs.length){
            version = idxs.length;
        }
        sameVersionIdxs.push(idxs[version-1]);
    }
    return sameVersionIdxs;
}

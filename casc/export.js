var fs=require('fs');
var path=require('path');
var yhnode=require("yhnode");

var ArgParser=yhnode.base.ArgParser;
var mkdirs=yhnode.filesystem.Path.mkdirs;
var Task=yhnode.async.Task;
var WorkPool=yhnode.async.WorkPool;

var IndexFile=require("./IndexFile.js").IndexFile;


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
	   full: 'sortEntry', 
	   abbr: 'se',
	   defaultValue:false
   }
];

var result=ArgParser.parse(opts);

var srcPath=result.options.src || "data";
var outPath=result.options.out || "out";
var sortEntry = result.options.sortEntry;

var idxGroup = IndexFile.getIdxFiles(srcPath);
exportAllIdxs(idxGroup,outPath,sortEntry);

function exportAllIdxs(idxGroup,outDir,sortEntry){
    mkdirs(outDir);
    for(var i in idxGroup){
        for(var j in idxGroup[i]){
           var idxInfo=idxGroup[i][j];
           IndexFile.loadIdxEntries(idxInfo);
           var fileName=IndexFile.getFileName(idxInfo)+".csv";
           var filePath=path.join(outDir,fileName);
           if(sortEntry){
                idxInfo.entries.sort(IndexFile.sortIdxEntries);
           }
           outCsvData(filePath,idxInfo.entries);
        }
    }
}

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

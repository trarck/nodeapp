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
   }
];

var result=ArgParser.parse(opts);

var srcPath=result.options.src;
var outPath=result.options.out || "out";

var entries =IndexFile.readIdxEntiesFromFile(srcPath);
console.log(entries.length);
analyzeIdx(entries);

function analyzeIdx(entries){
    var idxs={}
    var keys={};
    var size=0;
    for(var i in entries){
        var entry=entries[i];
        
        size+=entry.size;

        if (idxs[entry.index]==undefined){
             idxs[entry.index]=0;
        }else{
            idxs[entry.index] +=1;
        }
        
        if (keys[entry.key]==undefined){
             keys[entry.key]=0;
        }else{
            keys[entry.key] +=1;
        }
    }
    
    console.log("size:",size,size/1024/1024);
    
    for(var idx in idxs){
        console.log(idx,idxs[idx]);
    }
    
    for(var key in keys){
        if(keys[key]>0){
            console.log(key,keys[idx]);
        }
    }
}
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
	   full: 'model', 
	   abbr: 'm',
	   defaultValue:"check"
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
switch(action){
    case "check":
        checkIdxVersion(idxGroup);
        break;
}


function checkIdxVersion(idxGroup){
    for(var i in idxGroup){
        checkSameIdxVersion(idxGroup[i])
    }
}
function checkSameIdxVersion(idxs){
    for(var i=0;i<idxs.length-1;++i){
        console.log("check",idxs[i].type,idxs[i].version,idxs[i+1].version);
        var diff=diffIdxVersion(idxs[i],idxs[i+1]);
        if(diff.updates.length>0){
            console.log("updates ",diff.updates.length,idxs[i].type,idxs[i].version,idxs[i+1].version);
            var updates=[]
            for(var k in diff.updates){
                var u={
                    key:diff.updates[k].from.key,
                    fromIndex:diff.updates[k].from.index,
                    fromDataIndex:diff.updates[k].from.dataIndex,
                    fromOffset:diff.updates[k].from.offset,
                    fromSize:diff.updates[k].from.size,
                    toIndex:diff.updates[k].to.index,
                    toDataIndex:diff.updates[k].to.dataIndex,
                    toOffset:diff.updates[k].to.offset,
                    toSize:diff.updates[k].to.size
                };
                updates.push(u);
            }
            
            var fromIdxName=IndexFile.getFileName(idxs[i]);
            var toIdxName=IndexFile.getFileName(idxs[i+1]);
            var removeFileName=fromIdxName+"--"+toIdxName+".updates.csv";
            outCsvData(path.join(outPath,removeFileName),updates);
        }
        if(diff.removes.length>0){
            console.log("remove ",diff.removes.length,idxs[i].type,idxs[i].version,idxs[i+1].version);
            var fromIdxName=IndexFile.getFileName(idxs[i]);
            var toIdxName=IndexFile.getFileName(idxs[i+1]);
            var removeFileName=fromIdxName+"--"+toIdxName+".removes.csv";
            outCsvData(path.join(outPath,removeFileName),diff.removes);
        }
    }
}

function diffIdxVersion(verA,verB){
    var adds=[];
    var removes=[];
    var updates=[];
    var keys={};
    var aEntries={};
    
    for(var i in verA.entries){
        var entry=verA.entries[i];
        
        keys[entry.key] = true;
        aEntries[entry.key]=entry;
    }
       
    for(var i in verB.entries){
        var entry=verB.entries[i];
        
        if(!aEntries[entry.key]){
            adds.push(entry);
        }else{
            var aEntry = aEntries[entry.key];
            if(aEntry.dataIndex == entry.dataIndex && aEntry.offset == entry.offset && aEntry.size == entry.size){
                //sames
            }else{
                updates.push({from:aEntry,to:entry});
            }
            keys[entry.key]=false;
        }
    }
    
    for(var k in keys){
        if(keys[k]){
            removes.push(aEntries[k]);
        }
    }
    
    return {adds:adds,updates:updates,removes:removes};
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

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

var idxs = groupIdxFiles(srcPath);
exportAllIdxs(idxs,outPath,sortEntry);

// console.log(idxs[0].length);
// var vers=yhnode.base.Core.clone(idxs[0]);
// vers.sort(sortIdxByVersionAsc)
// loadAllIdxVersionEntries(vers);
// vers[1].entries.sort(sortIdxEntries);
// outCsvData(vers[0].type+"."+vers[0].version+".csv",vers[0].entries);
// outCsvData(vers[1].type+"."+vers[1].version+".csv",vers[1].entries);
// var diff=diffIdxVersion(vers[0],vers[1]);
//console.log(diff);
// var entries =IndexFile.readIdxEntiesFromFile(srcPath);
// console.log(entries.length);
// analyzeIdx(entries);
function exportAllIdxs(idxs,outDir,sortEntry){
    mkdirs(outDir);
    for(var i in idxs){
        for(var j in idxs[i]){
           var idxInfo=idxs[i][j];
           loadIdxEntries(idxInfo);
           var fileName=IndexFile.getFileName(idxInfo)+".csv";
           var filePath=path.join(outDir,fileName);
           if(sortEntry){
                idxInfo.entries.sort(sortIdxEntries);
           }
           outCsvData(filePath,idxInfo.entries);
        }
    }
}

function groupIdxFiles(idxDir){
    var files=fs.readdirSync(idxDir);
	
	var filename;
	var srcFile;
	var stat;
    var idxs={};
	for(var i in files){
		filename=files[i];
		if (filename!="." && filename!=".."){
			srcFile= path.join(idxDir,filename);
			stat=fs.statSync(srcFile);
			if (stat.isFile() && path.extname(filename)==".idx") {
				var idxInfo = IndexFile.getIdxInfo(srcFile);	
                if(!idxs[idxInfo.type]){
                    idxs[idxInfo.type]=[];
                }
                idxs[idxInfo.type].push(idxInfo);
			}
		}
	}
    return idxs;
}

function loadAllIdxVersionEntries(idxInfos){
    for(var i in idxInfos){
        loadIdxEntries(idxInfos[i]);
    }
}

function loadIdxEntries(idxInfo){
    if(!idxInfo.entries){
        idxInfo.entries=IndexFile.readIdxEntiesFromFile(idxInfo.file);
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
            if(aEntry.index == entry.index && aEntry.offset == entry.offset && aEntry.size == entry.size){
                //sames
            }else{
                updates.push(entry);
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

function sortIdxByVersionAsc(a,b){
    return a.version-b.version;
}

function sortIdxEntries(a,b){
    var r=a.index-b.index;
    if(r==0){
        r= a.offset-b.offset;
    }
    return r;
}

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

function outCsvData(filePath,arr){
    var cnt="";
    for(var i in arr){
        for(var k in arr[i]){
            cnt+=arr[i][k]+","
        }
        cnt+="\n";
    }
    fs.writeFileSync(filePath,cnt);
}

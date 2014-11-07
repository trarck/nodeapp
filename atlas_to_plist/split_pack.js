var fs=require("fs");
var path=require("path");
var exec = require('child_process').exec;
var yhnode=require("yhnode");

var ArgParser=yhnode.base.ArgParser;
var mkdirs=yhnode.filesystem.Path.mkdirs;
var Task=yhnode.async.Task;
var WorkPool=yhnode.async.WorkPool;

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
	   full: 'partName', 
	   abbr: 'p',
	   defaultValue:""
   },
   { 
	   full: 'textureName', 
	   abbr: 't',
	   defaultValue:""
   }
 ];

var result=ArgParser.parse(opts);

var srcPath=result.options.src;
var outPath=result.options.out || "out";
var partName=result.options.partName || "";
var textureName=result.options.textureName || "";

var splitApp="";

if(process.platform=="darwin"){
	//macosx
	splitApp="splittp";
}else{
	//win32
	splitApp="";
}

var wp=new WorkPool(5,"parseDir");

parseDir(srcPath,outPath);

function parseDir(srcDir,outDir){
	
	mkdirs(outDir);
	
	var files=fs.readdirSync(srcDir);

	for(var i in files){
		var file=files[i];
		if (file[0]!=".") {
			wp.add(parseFile,null,file,srcDir,outDir);
		}
	}
}

function parseFile(task,file,srcDir,outDir){
	
	var fullPath=path.join(srcDir,file);
	var stat=fs.statSync(fullPath);
	if(stat.isDirectory()){
		parseDir(fullPath,path.join(outDir,file));
		task.done();
	}else{
		
		var ext=path.extname(file);

		if(ext==".plist"){
			var splitTo= outDir;
			if(partName){
				if(partName=="AsPlist"){
					splitTo=path.join(outDir,path.basename(file,ext));
				}else{
					splitTo=path.join(outDir,partName);
				}
			}
			
			splitFile(fullPath,splitTo,textureName && path.join(srcDir,textureName),task);
		}else{
			task.done();
		}
	}
}


function splitFile(srcfile,outDir,textureFile,task){

	var cmd=getSplitCmd(srcfile,outDir,textureFile);

	console.log("exec:",cmd);
	
	exec(cmd,function(err){
		if(err){
			console.log("[convert err]("+srcfile+"):",err);
		}else{
			
		}
		
		task && task.done();
	});
}


function getSplitCmd(plistFile,outFile,textureFile){
	if(process.platform=="darwin"){
		//macosx
		return splitApp+" "+ plistFile+" "+outFile+" " +textureFile;
	}else{
		//win32
		return;
	}
}
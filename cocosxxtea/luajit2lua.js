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
	   full: 'ext', 
	   abbr: 'e',
	   defaultValue:""
   }
];

var result=ArgParser.parse(opts);

var srcPath=result.options.src;
var outPath=result.options.out || "out";
var extFilter=result.options.ext;


var decodeApp="";

if(process.platform=="darwin"){
	//macosx
	decodeApp="python "+path.join("tools","ljd","main.py");

}else{
	//win32
	decodeApp="python "+path.join("tools","ljd","main.py");
}


var wp=new WorkPool(5,"parseDir");

parseDirs(srcPath,outPath);

function parseDirs(dir,outDir){
	
	mkdirs(outDir);
	
	var files=fs.readdirSync(dir);

	for(var i in files){
		var file=files[i];
		if (file[0]!=".") {
			wp.add(parseTask,null,file,dir,outDir);
		}
	}
}

function parseTask(task,file,srcDir,outDir){
	var fullPath=path.join(srcDir,file);
	var stat=fs.statSync(fullPath);
	if(stat.isDirectory()){
		parseDirs(fullPath,path.join(outDir,file));
		task.done();
	}else{
		var ext=path.extname(file);
		if(!extFilter|| extFilter == "" || ext==extFilter){
			var outFile=path.basename(file,ext)+".lua";
			outFile=path.join(outDir,outFile);
			decodeLuac(task,fullPath,outFile);
		}else{
			task.done();
		}
	}
}

function decodeLuac(task,filename,outFile){

	var cmd=decodeApp+" "+filename+" > "+outFile;

	console.log("decode:",cmd);
	
	exec(cmd,function(err){
		task.done();
		if(err){
			console.log("[decode err]("+filename+"):",err);
		}else{
			console.log("success",outFile);
		}
	});
}
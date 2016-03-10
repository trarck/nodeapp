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
	   full: 'temp', 
	   abbr: 't',
	   defaultValue:""
   }
 ];

var result=ArgParser.parse(opts);

var srcPath=result.options.src;
var outPath=result.options.out || "out";
var tempPath=result.options.temp || "temp";

var lzmaApp="";

if(process.platform=="darwin"){
	//macosx
	lzmaApp="splittp";
}else{
	//win32
	lzmaApp="lzma.exe";
}

var wp=new WorkPool(5,"parseDir");

parseDir(srcPath,outPath,tempPath);

function parseDir(srcDir,outDir,tempDir){
	
	mkdirs(outDir);
	mkdirs(tempDir);
	
	var files=fs.readdirSync(srcDir);

	for(var i in files){
		var file=files[i];
		if (file[0]!=".") {
			wp.add(parseFile,null,file,srcDir,outDir,tempDir);
		}
	}
}

function parseFile(task,file,srcDir,outDir,tempDir){
	
	var fullPath=path.join(srcDir,file);
	var stat=fs.statSync(fullPath);
	if(stat.isDirectory()){
		parseDir(fullPath,path.join(outDir,file),path.join(tempDir,file));
		task.done();
	}else{
		
		var ext=path.extname(file);

		if(ext==".csv"||ext==".sc"){
			unpackFile(fullPath,path.join(outDir,file),path.join(tempDir,file),task);
		}else{
			task.done();
		}
	}
}


function unpackFile(srcfile,outfile,tempfile,task){
	fixFileHead(srcfile,tempfile)
	var cmd=lzmaApp+" d "+tempfile+" "+outfile;

	console.log("exec:",cmd);
	
	exec(cmd,function(err){
		if(err){
			console.log("[convert err]("+srcfile+"):",err);
		}else{
			
		}
		
		task && task.done();
	});
}

function fixFileHead(srcfile,tempfile)
{
	var buff=fs.readFileSync(srcfile);
	var newBuff=new Buffer(buff.length+4);

	buff.copy(newBuff,0,0,9);
	newBuff.writeInt32LE(0,9);
	buff.copy(newBuff,13,9);
	fs.writeFileSync(tempfile,newBuff);
}
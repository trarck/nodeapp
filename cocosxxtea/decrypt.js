var fs=require('fs');
var fs=require("fs");
var path=require("path");

var yhnode=require("yhnode");

var ArgParser=yhnode.base.ArgParser;
var mkdirs=yhnode.filesystem.Path.mkdirs;
var Task=yhnode.async.Task;
var WorkPool=yhnode.async.WorkPool;
var xxtea=require("./xxtea");

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
   },
   { 
	   full: 'key', 
	   abbr: 'k',
	   defaultValue:""
   }, 
   { 
	   full: 'sign', 
	   abbr: 'i',
	   defaultValue:""
   }
];

var result=ArgParser.parse(opts);

var srcPath=result.options.src;
var outPath=result.options.out || "out";
var extFilter=result.options.ext;
var xxteaKey=result.options.key||"xxtea";
var xxteaSign=result.options.sign||"xxtea";

var wp=new WorkPool(5,"parseDir");

parseDirs(srcPath,outPath);

function parseDirs(dir,outDir){
	console.log("dir:",dir,outDir);
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
		if(file.charAt(0)!="." && (!extFilter || extFilter == "" || ext==extFilter)){
			var outFile=path.join(outDir,file);
			decrypt(task,fullPath,outFile);
		}else{
			task.done();
		}
	}
}

function decrypt(task,filename,outFilename)
{
	console.log("decrypt "+filename+"=>"+outFilename);
	var cnt=fs.readFileSync(filename);
	var decryptCnt=xxtea.decrypt(cnt.slice(xxteaSign.length),xxteaKey);
	var decryptBuff=new Buffer(decryptCnt);
	fs.writeFileSync(outFilename,decryptBuff);
	task.done();
}
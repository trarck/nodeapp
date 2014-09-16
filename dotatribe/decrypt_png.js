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
	   full: 'key', 
	   abbr: 'k',
	   defaultValue:""
   }, 
   { 
	   full: 'cryptSize', 
	   abbr: 'c',
	   defaultValue:""
   }
];

var result=ArgParser.parse(opts);

var srcPath=result.options.src;
var outPath=result.options.out || "out";

var key=result.options.key||"com.cyou.mrd.dotatribeimage87564";
var cryptSize=result.options.cryptSize||200;

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
		if(ext==".png"){
			var outFile=path.join(outDir,file);
			decryptPng(task,fullPath,outFile);
		}else{
			task.done();
		}
	}
}

function decryptPng(task,filename,outFile){

	fs.readFile(filename,function(err,buf){
		if(!err){
			var bufSize=buf.length;
			
			for(var i=0;i<bufSize && i<cryptSize;i++){
				buf[i]=buf[i] ^ key.charCodeAt(i % key.length);
			}

			fs.writeFileSync(outFile,buf);
			task.done();
			console.log("decryptPng done:"+filename);
		}else{
			console.log("err:decryptPng",err);
		}
	});	
}




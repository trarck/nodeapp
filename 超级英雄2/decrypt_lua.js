var fs=require("fs");
var path=require("path");
var exec = require('child_process').exec;
var yhnode=require("yhnode");

var ArgParser=yhnode.base.ArgParser;
var mkdirs=yhnode.filesystem.Path.mkdirs;
var Task=yhnode.async.Task;
var WorkPool=yhnode.async.WorkPool;

var keys=[ 135,162,145,187,241,227,169,126,76,151,48,215,156,21,76,18,3,176,46,238,236,8,254,206,154,141,120,82,158,238,14,214,165,68,133,155,120,158,58,168,91,98,219,14,16,70,162,13,244,123,121,102,251,149,103,205,204,203,21,165,145,233,17,15,16,19,3,189,70,124,70,144,79,62,250,162,149,170,12,158,16,128,205,54,73,3,220,253,22,64,132,205,28,3,115,177,208,189,119,75];

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

		if(ext==".lua"){
			var outFile=path.join(outDir,file);
			decryptLua(task,fullPath,outFile);
		}else{
			task.done();
		}
	}
}

function decryptLua(task,filename,outFile){

	fs.readFile(filename,function(err,buf){
		if(!err){
			if (buf[0]==76 && buf[1]==117 && buf[2]==97) {
				
                var offset=3;       
                var out=new Buffer(buf.length-offset);      
				
				for(var i=0;i<buf.length-offset;++i){
                    out[i]=buf[i+offset] - keys[i%keys.length];
                }


				fs.writeFileSync(outFile,out);
				console.log("decryptPng done:"+filename);
			}else{
                fs.writeFileSync(outFile,buf);
				console.log("no crypt:",filename);
			}

			task.done();
			
		}else{
			console.log("err:decryptPng",err);
		}
	});	
}




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
		if(ext==".png"){
			var outFile=path.join(outDir,file);
			decryptPng(task,fullPath,outFile);
		}else if(ext==".jpg"){
			var outFile=path.join(outDir,file);
			decryptJpg(task,fullPath,outFile);
		}else{
			task.done();
		}
	}
}

function decryptPng(task,filename,outFile){

	fs.readFile(filename,function(err,buf){
		if(!err){
			
			if (buf[0]==0x53 && buf[1]==0x44) {
				
				buf[0]=0x89;
				buf[1]=0x50;
				
				var offset=8;//png first chunk data size
				
				var cryptSize=buf.readUInt32BE(offset)+4;
				offset+=8;//skip chunk name;
				
				decryptData(buf,offset,cryptSize,0x50);

				fs.writeFileSync(outFile,buf);
				console.log("decryptPng done:"+filename);
			}else{
				console.log("no crypt:",filename);
			}

			task.done();
			
		}else{
			console.log("err:decryptPng",err);
		}
	});	
}

function decryptJpg(task,filename,outFile){

	fs.readFile(filename,function(err,buf){
		if(!err){
			
			if (buf[0]==0x53 && buf[1]==0x44) {
				
				buf[0]=0xFF;
				buf[1]=0xD8;
				
				var fileSize=buf.length;
				
				for (var i = 2; i +1 < fileSize; i++) {
						
					if (buf[i]==0xFF && buf[i+1]==0xC0) {
						
						var offset=i+2;//jpg chunk data size
				
						var cryptSize=buf.readUInt16BE(offset);
							
						if (cryptSize>2) {
							offset+=2;
							decryptData(buf,offset,cryptSize-2,0x4A);
						}
						
						break;
						
					}
				}

				fs.writeFileSync(outFile,buf);
				console.log("decryptPng done:"+filename);
			}else{
				console.log("no crypt:",filename);
			}

			task.done();
			
		}else{
			console.log("err:decryptPng",err);
		}
	});	
}

function decryptData(buf,offset,cryptSize,baseKey) {
	
	var key;
	for(var i=0;i<Math.floor(cryptSize/2);i++){
		key=(baseKey+i) % 255;
					
		tmp=buf[offset+i] ^ key;

		buf[offset+i]=buf[offset+cryptSize-i-1] ^ key;
		buf[offset+cryptSize-i-1]=tmp;
	}
}




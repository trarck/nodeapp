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
	   full: 'cryptSize', 
	   abbr: 'c',
	   defaultValue:""
   }
];

var result=ArgParser.parse(opts);

var srcPath=result.options.src;
var outPath=result.options.out || "out";

var key=[0x11, 0x2B, 0x65, 0xF3, 0x17, 0xC, 0xD, 0x13, 0x15,
		 0x35, 0x62, 0x6F, 0x7B, 0x62, 0x15, 0xE7, 0x11, 0x2C,
		 0x63, 0x17, 0x16, 0x57, 0xC, 0x59, 0xB2, 0x20, 0x65,
		 0x21, 0x20, 0x63, 0xC, 0x7F, 8
];

var cryptSize=result.options.cryptSize||95;
var headSize=5;

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
			
			if(bufSize>4 && buf[0]==0x55 && buf[1]==0x46){
				var type=buf[2];
				var version=buf[3];
				
				var plainBuf=null;
				
				if(version==2){
					plainBuf=decryptVer2(buf);
				}else if(version==1){
					plainBuf=decryptVer1(buf);
				}
				
				if(plainBuf){
					fs.writeFileSync(outFile,plainBuf);
					console.log("decryptPng done:"+filename);
				}else{
					console.log("err:decryptPng unknow version:"+version+" for "+filename);
				}
			}else{
				console.log("decryptPng none:"+filename);
			}
			
			task.done();
		}else{
			console.log("err:decryptPng",err);
		}
	});	
}

function decryptVer1(buff){

	var realSize=buff.length-headSize;
	
	if(realSize>=1){
		var keyPos=buff[4];
		var plainPos=0;
		
		for(var i=0;i<realSize;++i,++plainPos){
			buff[plainPos] = key[keyPos++%key.length] ^ buff[plainPos+5];
		}
		
		return buff.slice(0,realSize);
		
	}else{
		return null;
	}
}

function decryptVer2(buff){
	var keyPos=buff[4];
	
	var realSize=buff.length-headSize;
	
	var plainPos=0;
	
	var cryptPos=buff.length-headSize;
	
	for(var i=0;i<5;++i){
		buff[plainPos+i]=key[(keyPos+i)%key.length]^buff[cryptPos+i];
	}
	
	var leftSize=realSize-headSize;
	
	if(leftSize<=cryptSize ){
		if(realSize>6){
			leftSize=cryptSize;
		}else{
			return buff;
		}
	}
	
	plainPos+=headSize
	keyPos+=headSize;
	
	var cryptLength=buff.length+(cryptSize-headSize*2)-leftSize;	
	for(var i=0;i<cryptLength;++i){
		buff[plainPos++] ^=key[keyPos++%key.length];
	}
	
	return buff.slice(0,realSize);
}
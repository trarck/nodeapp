var fs=require("fs");
var path=require("path");
var yhnode=require("yhnode");

var ArgParser=yhnode.base.ArgParser;
// var zlib=require("zlib");

//contains IHDR sign
var pngHeader=fs.readFileSync("pngHeader");
var pngEnder=fs.readFileSync("pngEnder");


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
	   full: 'srcExt', 
	   abbr: 'se',
	   defaultValue:".p"
   }, 
   { 
	   full: 'distExt', 
	   abbr: 'de',
	   defaultValue:".png"
   },
   { 
	   full: 'removeSource', 
	   abbr: 'rs',
	   defaultValue:false
   }
];

var result=ArgParser.parse(opts);
// console.log(result);

var srcPath=result.options.src||"./";
var outPath=result.options.out||srcPath;

var pngExt=result.options.distExt||".png";
var srcExt=result.options.srcExt||".p";

var removeSourceFile=result.options.removeSource||false;

parseDir(srcPath,outPath);

// parseFile("CloverAssets/gameUI/homeUI/button-goon.p","ttt.png");

function parseDir(dir,distDir){
	
	mkdirs(distDir);
	
	var files=fs.readdirSync(dir);
	
	var filename;
	var srcFile;
	var stat;
	for(var i in files){
		filename=files[i];
		if (filename!="." && filename!=".."){
			srcFile=dir+filename;
			stat=fs.statSync(srcFile);
			if (stat.isFile() && path.extname(filename)==srcExt) {
			
				parseFile(srcFile,distDir+getDistFileName(filename));
			
			}else if(stat.isDirectory()){
				parseDir(dir+filename+"/",distDir+filename+"/");
			}
		}
	}
}

function parseFile(file,distFile){
	
	console.log("parse "+file);
	
	var cnt=fs.readFileSync(file);

	var offset=0;
	//内容大小
	var size=cnt.readUInt32BE(offset);
	offset+=4;
	//块的大小
	var chunkSize=cnt.readUInt16BE(offset);
	// console.log(size,chunkSize);

	//去除头，得到实际的png文件
	var realCnt=cnt.slice(6);
	
	//转换后的内容
	var dist=new Buffer(size);

	var chunkOffset=size;
	var distOffset=0;

	var flag=true;
	
	//得到源文件。
	//加密后的文件是按照块倒序，但是块的内部是正序的。
	//这里要从最后向前读块的内容。
	while(flag){
		chunkOffset-=chunkSize;

		if (chunkOffset<=0) {
			chunkOffset=0;
			flag=false;
		}
		// console.log("copy",distOffset,chunkOffset,chunkOffset+chunkSize);
		realCnt.copy(dist,distOffset,chunkOffset,chunkOffset+chunkSize);

		distOffset+=chunkSize;
	}

	//写入文件
	var fd=fs.openSync(distFile,"w");
	
	var writePos=0;
	
	//写入头
	fs.writeSync(fd,pngHeader,0,pngHeader.length,writePos);
	writePos+=pngHeader.length;
	
	//写入内容
	fs.writeSync(fd,dist,0,dist.length,writePos);
	writePos+=dist.length;

	//写入尾
	fs.writeSync(fd,pngEnder,0,pngEnder.length,writePos);

	fs.close(fd);
	
	if (removeSourceFile) {
		fs.unlink(file);
	}
}

function getDistFileName(filename){
	return path.basename(filename,srcExt)+pngExt;
}

function mkdirs(dir){
	var paths=[];
	while(!fs.existsSync(dir)){
		paths.push(dir);
		dir=path.dirname(dir);
	}
	while(p=paths.pop()){
		fs.mkdirSync(p);
	}
}

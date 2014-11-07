//刀塔联盟
var fs=require("fs");
var path=require("path");
var exec = require('child_process').exec;
var yhnode=require("yhnode");
var plist=require("plist");

var ArgParser=yhnode.base.ArgParser;
var mkdirs=yhnode.filesystem.Path.mkdirs;
var Task=yhnode.async.Task;
var WorkPool=yhnode.async.WorkPool;


// var obj = plist.parse(fs.readFileSync('temp/plist.plist', 'utf8'));
// console.log(JSON.stringify(obj,null,4));

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
		if(ext==".atlas"){
			
			var outFile=path.join(outDir,path.basename(file,ext)+".plist");
			
			parseFile(task,fullPath,outFile);
		}else{
			task.done();
		}
	}
}

function parseFile(task,filename,outFile){

	fs.readFile(filename,function(err,buf){
		if(!err){
			var data=convert(buf.toString());
			if(data){
				var plistData=plist.build(data);
				fs.writeFileSync(outFile,plistData);
				console.log("convert done:"+filename+" to "+outFile);
			}else{
				console.log("err:convert",err);
			}
			
		}else{
			console.log("err:convert",err);
		}
		
		task.done();
	});	
}

function convert(atlas){
	atlas=atlas.replace(new RegExp("\r","g"),"");
	
	var lines=atlas.split("\n");
	
	var len=lines.length;
	if(len<=4) return "";
	
	var i=0;
	
	var out={
		frames:{},
		metadata:{
			format:2
		}
	}
	
	//get metedata
	//first not empty line is png
	while(!lines[i]){
		i++;
	}
	
	out.metadata.realTextureFileName=lines[i];
	out.metadata.textureFileName=lines[i];
	
	//TODO get size
	
	//skip 3
	i+=4;
	
	var line;
	//get Data
	while(i<len){
		
		var line=lines[i];
		if(line.trim()=="") break;
		
		// console.log("line:",i,line);
		if(line[0]==" "){
			console.log("err data format");
			return "";
		}
		
		var name=line;
		
		i+=1;
		
		var ts;
		var key,value;
		
		var rotated,x,y,size={},orig={},offset={};
		
		while((line=lines[i])[0]==" "){
			line=line.trim();
			ts=line.split(":");
			key=ts[0];
			value=ts[1].trim();
			
			switch(key){
				case "rotate":
					rotated=value=="true"?true:false;
					break;
				case "xy":
					ts=value.split(",");
					x=parseInt(ts[0]);
					y=parseInt(ts[1]);
					break;
				case "size":
					ts=value.split(",");
					size.width=parseInt(ts[0]);
					size.height=parseInt(ts[1]);
					break;
				case "orig":
					ts=value.split(",");
					orig.width=parseInt(ts[0]);
					orig.height=parseInt(ts[1]);
					break;
				case "offset":
					ts=value.split(",");
					offset.x=parseInt(ts[0]);
					offset.y=parseInt(ts[1]);
					break;
				case "index":
					break;
			}
			++i;
		}
		
		var colorOffsetX=offset.x;
		var colorOffsetY=orig.height-offset.y-size.height;
		
		var cocosOffsetX=size.width/2+colorOffsetX-orig.width/2;
		var cocosOffsetY=orig.height/2-(size.height/2+colorOffsetY);
		
		out.frames[name+".png"]={
			frame:"{{"+x+","+y+"},{"+size.width+","+size.height+"}}",
			rotated:rotated,
			offset:"{"+cocosOffsetX+","+cocosOffsetY+"}",
			sourceColorRect:"{{"+colorOffsetX+","+colorOffsetY+"},{"+size.width+","+size.height+"}}",
			sourceSize:"{"+orig.width+","+orig.height+"}"
		};
	}
	
	// console.log(out);
	
	return out;

}

function getFrame(lines,p){
	
	if(lines[p][0]!=" "){
		console.log("err data format");
		process.exit(2);
	}
	
	
	
}




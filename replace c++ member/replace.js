var fs=require("fs");
var path=require("path");
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

var regEx=/_([nlucfdbspt][A-Z]\w*)/g;

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
		if(ext==".h" || ext==".cpp"){
			var outFile=path.join(outDir,file);
			changeFile(task,fullPath,outFile);
		}else{
			task.done();
		}
	}
}


function changeFile(task,srcFile,outFile){
	console.log("pare file",srcFile);

	fs.readFile(srcFile,"utf8",function(err,content){
		
		if (!err){
			content=changeName(content)
            if (content)
            {
                fs.writeFileSync(outFile,content);
            }else{
                console.log("not replace:",srcFile);
            }
			
		}else{
			console.log("err:",srcFile,err);
		}

		task.done();
	})
}

function changeName(content){

	var map={};

	var ret=content.match(regEx);
		
	if (!ret)
	{
		return false;
	}

	for(var i=0;i<ret.length;i++){
		var k=ret[i];
		var key=k.substr(1);
	
		if (!map[key]){
			var replaceTo=getReplaceName(k);
			map[key]=replaceTo
		}
	}

	//console.log(ret,map);

	for(var k in map){
		content=content.replace(new RegExp("([^a-zA-Z])"+k, 'g'),"$1"+map[k]);
	}
	
	//console.log(content);

	return content
}

function getReplaceName(name){

	var first=name.substr(2,1);

	name=name.substr(3);

	return first.toLowerCase()+name;
}

function formatName(name){

	var first=name.substr(2,1);

	name=name.substr(3);

	return "_"+first.toLowerCase()+name;
}

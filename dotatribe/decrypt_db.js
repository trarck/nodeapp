//刀塔联盟
var fs=require("fs");
var path=require("path");
var exec = require('child_process').exec;

var sqlite3 = require('sqlite3').verbose();
	
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
   }
];

var result=ArgParser.parse(opts);

var srcPath=result.options.src;
var outPath=result.options.out || "out";

var key=result.options.key||"com.cyou.mrd.dota97tribe9527";


mkdirs(outPath);

decryptDb(srcPath,outPath);


function decryptDb(dbPath){
	var db = new sqlite3.Database(dbPath);
  
	db.each( 'SELECT name FROM sqlite_master where type="table"', function (error, row) {
		console.log("decrypt:",row.name);
		dectyptTable(db,row.name);
    });
	
}

function dectyptTable(db,table){
	db.get( 'SELECT data FROM '+table, function (error, row) {
		dectyptData(row.data,table);
    });
}

function dectyptData(data,table){
	
	for(var i=0;i<data.length;++i){
		data[i] ^= key.charCodeAt(i%key.length);
	}

	fs.writeFileSync(path.join(outPath,table+".dat"),data);
}







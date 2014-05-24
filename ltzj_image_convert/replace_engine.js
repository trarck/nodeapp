var fs=require("fs");
var path=require("path");
var zlib=require("zlib");
var yhnode=require("yhnode");
var Reader=require("./Reader").Reader;
var Writer=require("./Writer").Writer;
var InputStream=require("./InputStream").InputStream;
var OutputStream=require("./OutputStream").OutputStream;

var ArgParser=yhnode.base.ArgParser;

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
	   full: 'targetIndex', 
	   abbr: 'ti',
	   defaultValue:""
   }, 
   { 
	   full: 'sourceIndex', 
	   abbr: 'si',
	   defaultValue:""
   }
];

var result=ArgParser.parse(opts);

var srcFile=result.options.src;
var outFile=result.options.out||(srcFile+".md");


var targetIndex=result.options.targetIndex||0;
var sourceIndex=result.options.sourceIndex||4;

var cnt=fs.readFileSync(srcFile);

var reader=new Reader(cnt);

var engineConfig=reader.readEngineConfig();


var targetRecords=getRecordsByIndex(engineConfig.data,targetIndex);
var sourceRecords=getRecordsByIndex(engineConfig.data,sourceIndex);

for (var i = 0; i < targetRecords.length; i++) {
	replaceEngineConfigRecord(
		targetRecords[i],
		sourceRecords[i]
	);
}

var writer=new Writer(cnt.length);
writer.writeEngineConfig(engineConfig);
writer.saveTo(outFile);


//把target里的内容用source替换
function replaceEngineConfigRecord(targetRecord,sourceRecord){
	//只替换描述后面的内容,也就是从icon开始
	var iconIndex=8;
	for (var i = iconIndex; i < targetRecord.length; i++) {
		targetRecord[i]=sourceRecord[i];
	}
}

function getRecordsByIndex(data,index){
	
	var records=[];
	
	for (var i = 0; i < data.length; i++) {
		if (data[i][0]==index) {
			records.push(data[i]);
		}
	}
	return records;
}



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
   }
];

var result=ArgParser.parse(opts);

var srcFile=result.options.src;
var outFile=result.options.out||(srcFile+".md");

function SimpleReader(buffer){
	
	this.stream=new InputStream(buffer);
	
}

SimpleReader.prototype={
	
	readEngineRecord:function (){
	
		var stream=this.stream;
		
		var index=stream.readUInt16BE();

		var itemId=stream.readUInt16BE();
		var itemName=this.readString();

		var num11=stream.readUInt8();
		var fromLevel=stream.readUInt16BE();//开始等级
	    var toLevel=stream.readUInt16BE();//结束等级		

		var type=this.readString();

		var description=this.readString();
	
		var configStartOffset=stream.getOffset();
				
		var icon=this.readString();

		var num21=stream.readFloatBE();
		var num22=stream.readFloatBE();
		var num23=stream.readFloatBE();
		var num24=stream.readFloatBE();

		var str01=this.readString();

	    var num31=stream.readUInt16BE();

		var level1=stream.readFloatBE();
		var level2=stream.readFloatBE();		
	
		var num41=stream.readFloatBE();
		var num42=stream.readFloatBE();

		var num51=stream.readUInt32BE();
		var base=stream.readFloatBE();
		var up=stream.readFloatBE();
		var num52=stream.readUInt32BE();
			

		var animationData=this.readString();
		var animationImage=this.readString();
		var bulletAnimationData=this.readString();
		var bulletAnimationImage=this.readString();

		var num61=stream.readUInt32BE();
		var num62=stream.readUInt8();
		var num63=stream.readFloatBE();
		var num64=stream.readFloatBE();
	
		var baozhou=this.readString();
				
		var skillName=this.readString();
	
		var configEndOffset=stream.getOffset();

		return [
		    index,
		    itemId,configStartOffset,configEndOffset
		];
	},

	readerEngineData:function (){
		
		var stream=this.stream;
	
		var data=[];
	
		var magicNumber=stream.readUInt32BE();
	
		var nouse=stream.readUInt32BE();
	
		var anum=stream.readUInt16BE();
	
		var  i=0;
	    var record;

		while(i++<100&& !stream.eof()){
		
			record=this.readEngineRecord();

	        data.push(record);
	
		}
	
	    return data;
	},

	//target is xunlei source is shenmo
	replaceRecord:function (outputStream,target,source){
			
		var targetStartOffset=target[2];
		
		var targetEndOffset=target[3];
	
		var sourceStartOffset=source[2];
		var sourceEndOffset=source[3];
	
		var buffer=outputStream.getBuffer();
		
		console.log(targetStartOffset.toString(16),sourceStartOffset.toString(16),sourceEndOffset.toString(16));
	
		buffer.copy(buffer,targetStartOffset,sourceStartOffset,sourceEndOffset);
		
		
	},

	getRecordByIndexAndId:function (data,index,id){
		for (var i = 0; i < data.length; i++) {
			if (data[i][0]==index && data[i][1]==id) {
				return data[i];
			}
		}
		return null;
	},
	
	getRecordsByIndex:function (data,index){
		
		var records=[];
		
		for (var i = 0; i < data.length; i++) {
			if (data[i][0]==index) {
				records.push(data[i]);
			}
		}
		return records;
	},
	
	readString:function(){
		var stream=this.stream;
		var strLength=stream.readUInt16BE();
		
		var strBuf=stream.readBytes(strLength);
		
		return strBuf.toString("utf8");
	}
};

var targetIndex=0;
var sourceIndex=4;

var cnt=fs.readFileSync(srcFile);

var simpleReader=new SimpleReader(cnt);

var engineData=simpleReader.readerEngineData();

var outputStream=new OutputStream(cnt);


var targetRecords=simpleReader.getRecordsByIndex(engineData,targetIndex);
var sourceRecords=simpleReader.getRecordsByIndex(engineData,sourceIndex);

for (var i = 0; i < targetRecords.length; i++) {
	simpleReader.replaceRecord(
		outputStream,
		targetRecords[i],
		sourceRecords[i]
	);
}

fs.writeFileSync(outFile,outputStream.getBuffer());



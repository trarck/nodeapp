var fs=require("fs");
var path=require("path");
var exec = require('child_process').exec;
var yhnode=require("yhnode");

var ArgParser=yhnode.base.ArgParser;

var key="key";

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
var outFile=result.options.out || "out";

decryptDoc(srcFile,outFile);

function decryptDoc(filename,outFile){

	fs.readFile(filename,function(err,buf){
		if(!err){
            var cnt=new Buffer(buf.toString(),"base64");
            var plain=decryptData(cnt,key);
            fs.writeFileSync(outFile,plain.toString());
		}else{
			console.log("err:decryptDoc",err);
		}
	});	
}

function decryptData(buf,key) {
    var bufKey=new Buffer(key);
    var keyLen=key.length;
    var out=new Buffer(buf.length);
    for(var i=0;i<buf.length;++i){
        out[i]=buf[i] ^ bufKey[i % keyLen];
    }
    return out;
}




var fs=require("fs");
var path=require("path");
var zlib=require("zlib");
var yhnode=require("yhnode");

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
var outFile=result.options.out||(srcFile+".zip");

var cnt=fs.readFileSync(srcFile);

zlib.gzip(cnt,function(err,buf){
	
	// console.log(err);
	// console.log(buf);
	fs.writeFileSync(outFile,buf);
});
var crypto = require('crypto') ;
var yhnode=require("yhnode");
var ArgParser=yhnode.base.ArgParser;

var algorithm="aes-128-cbc";

var opts= [
   { 
	   full: 'sign', 
	   abbr: 's',
	   defaultValue:""
   }, 
   { 
	   full: 'key', 
	   abbr: 'k',
	   defaultValue:""
   }
];

var result=ArgParser.parse(opts);

var sign=  result.options.sign||"cc087ad2d1df67bcb87db6262b45376d";
var key= result.options.key||"";//as the normal

var iv=new Buffer(16);
iv.fill(0);

var croptKey=new Buffer(16);
croptKey.fill(0);
croptKey.write(key);

var input=new Buffer(16)
input.fill(0);
input.write(sign,"hex");

// var ecipher =crypto.createCipheriv(algorithm, croptKey,iv);
// ecipher.setAutoPadding(false);
// var b1=ecipher.update(input);
// var b2=ecipher.final();
// var b3=Buffer.concat([b1,b2]);
// console.log(b3.toString("hex"));

var decipher = crypto.createDecipheriv(algorithm, croptKey,iv);
decipher.setAutoPadding(false);
var plainCnt=decipher.update(input);
plainCnt=Buffer.concat([plainCnt,decipher.final()]);
console.log(plainCnt.toString());
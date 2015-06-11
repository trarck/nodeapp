var crypto = require('crypto') ;
var fs=require('fs');
var zlib = require('zlib');
var path=require("path");
var yhnode=require("yhnode");
var exec = require('child_process').exec;

var ArgParser=yhnode.base.ArgParser;
var mkdirs=yhnode.filesystem.Path.mkdirs;
var Task=yhnode.async.Task;
var WorkPool=yhnode.async.WorkPool;

var algorithm="aes-256-cbc";

var password="bW89ej!4tSr&u?U&?";
var SaltKey="com.squareenixmontreal.hitmansniper";
var VIKey = "@5027edS453Fu28J";

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
var optType=result.cmds[0];

var cryptoKey="";
var wp=null;

createCryptoKey(password,SaltKey,function(err,key){
    if (err) throw err;
    cryptoKey=key;

    wp=new WorkPool(5,"parseDir");

    parseDirs(srcPath,outPath);
});


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
		var outFile=path.join(outDir,file);

        if (optType=="e"){
            encrypto(task,fullPath,outFile);
        }else{
            decrypto(task,fullPath,outFile);
        }
		
	}
}

function decrypto(task,srcFile,outFile){
    var content=fs.readFileSync(srcFile);

    var decipher=createDecipher(cryptoKey,VIKey);

    var plainCnt=decipher.update(content);
    plainCnt=Buffer.concat([plainCnt,decipher.final()]);

    decompress(plainCnt,outFile,function(){
        task.done();
    });

    
}


function decompress(plainCnt,outFile,cb){
    var tmpFile=outFile+".lzma";
    fs.writeFileSync(tmpFile,plainCnt,"binary");
    
    exec("lzma d "+tmpFile+" "+outFile,function(err){
        
        fs.unlinkSync(tmpFile);

        if (cb){
            cb();
        }
    });
}

function createCryptoKey(password,saltKey,callback){
    crypto.pbkdf2(password, saltKey, 0x3e8, 32, callback);
}

function createDecipher(key,iv){
    var keyBuff;

    if (key instanceof Buffer) {
        keyBuff=key;
    }else{
        keyBuff=new Buffer(32);
        keyBuff.fill(0);
        keyBuff.write(key);
    }

    var ivBuff=new Buffer(16);
    ivBuff.fill(0);
    ivBuff.write(iv);

    var decipher=crypto.createDecipheriv(algorithm, keyBuff,ivBuff);
    decipher.setAutoPadding(false);
    return decipher;
}


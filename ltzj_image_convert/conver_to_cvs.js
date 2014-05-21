var fs=require("fs");
var path=require("path");
var zlib=require("zlib");
var yhnode=require("yhnode");
var Reader=require("./Reader").Reader;

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
	   full: 'type', 
	   abbr: 't',
	   defaultValue:""
   }
];

var result=ArgParser.parse(opts);

var srcFile=result.options.src;
var outFile=result.options.out||(srcFile+".txt");
var type=result.options.type||"";

if (type) {
	
	console.log("read "+type);
	
	var cnt=fs.readFileSync(srcFile);

	var reader=new Reader(cnt);

	var config=null;
	
	switch(type){
		
		case "armor":
			config=reader.readArmorConfig();
			break;
		case "weapon":
			config=reader.readWeaponConfig();
			break;
		case "wingman":
			config=reader.readWingmanConfig();
			break;
		case "engine":
			config=reader.readEngineConfig();
			break;	
		case "loot":
			config=reader.readLootConfig();
			break;	
		default:
			break;
		
	}
	
	if (config) {
		fs.writeFileSync(outFile,output(config.data));
	}
}

function output(data){

    var outStr="";

    for(var j in data){

        var item=data[j];
        var first=true;
		
        for(var i in item){
            if(!first){
                outStr+=",";
            }else{
                first=false;
            }
			if (typeof(item[i])=="string") {
				outStr+='"' +item[i]+'"';
			}else{
				outStr+=item[i];
			}
			
            
        }
        outStr+="\n";
    }

    return outStr;
}
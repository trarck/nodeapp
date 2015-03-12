var fs=require("fs");
var ConvertFca=require("./ConvertFca");

var content=fs.readFileSync("temp/cha/Phoenix/cha.json");
var data=JSON.parse(content);

var convert=new ConvertFca(data,true);

var baseLayers=convert.makeBaseLayers(data.actions[8]);
//console.log(baseLayers);
//fs.writeFileSync("temp/b.js","var b="+JSON.stringify(baseLayers,null,4)+";");

//var action=convert.convertAction(data.actions[8]);

//var actions=convert.convertActions();
//fs.writeFileSync("temp/t.js","var a="+JSON.stringify(actions,null,4)+";");


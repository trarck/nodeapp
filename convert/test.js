var fs=require("fs");
var ConvertFca=require("./ConvertFca");

var content=fs.readFileSync("cha.json");
var data=JSON.parse(content);

var convert=new ConvertFca(data);

//var baseLayers=convert.makeBaseLayers(data.actions[3]);
//console.log(baseLayers);

//var action=convert.convertAction(data.actions[3]);

var actions=convert.convertActions();
fs.writeFileSync("temp/t.js","var a="+JSON.stringify(actions,null,4)+";");


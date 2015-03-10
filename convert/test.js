var fs=require("fs");
var ConvertFca=require("./ConvertFca");

var content=fs.readFileSync("cha.json");
var data=JSON.parse(content);

var convert=new ConvertFca(data);

var baseLayers=convert.makeBaseLayers(data.actions[5]);
console.log(baseLayers);
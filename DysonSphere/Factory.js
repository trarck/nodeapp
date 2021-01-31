var fs=require('fs');

function Factory(){
    
}

Factory.loadConfig=function (){
    var cnt=fs.readFileSync("./data/factory.json");
    var data=JSON.parse(cnt.toString());
    Factory.factories=data;
    Factory.map={};
    Factory.nameMap={};
    for(var i in data){
        var factory=data[i];
        if(factory.id){
            Factory.map[factory.id]=factory;
        }
        
        if(factory.name){
            Factory.map[factory.name]=factory;
        }
    }
}

Factory.getFactory=function(idOrName){
    return Factory.map[idOrName];
}

Factory.getFactoriesOfType=function(type){
    var ret=[];
    for(var i in Factory.factories){
        var factory=Factory.factories[i];
        if(factory.factoryType==type){
            ret.push(factory);
        }
    }
    return ret;
}

Factory.getFactoryOfType=function(type){
    var factories=Factory.getFactoriesOfType(type);
    if(factories!=null && factories.length>0){
        return factories[0];
    }
    return null;
}

module.exports=Factory;
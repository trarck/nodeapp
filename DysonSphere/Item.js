var fs=require('fs');

function Item(){
    
}

Item.loadConfig=function (){
    var cnt=fs.readFileSync("./data/Item.json");
    var data=JSON.parse(cnt.toString());
    Item.items=data;
    Item.map={};
    for(var i in data){
        var item=data[i];
        if(item.id){
            Item.map[item.id]=item;
        }
        
        if(item.name){
            Item.map[item.name]=item;
        }
    }
}

Item.getItem=function(idOrName){
    return Item.map[idOrName];
}

module.exports=Item;
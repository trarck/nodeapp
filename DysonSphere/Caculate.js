var Factory=require("./Factory.js");
var Item=require("./Item.js");
var Formula=require("./Formula.js");

initData();

//displayItemFormula("铁块");
caculateFactoryLines("电磁涡轮",6);

function initData(){
    Factory.loadConfig();
    Item.loadConfig();
    Formula.loadConfig();
}

function formatFormulaItem(fd){
    return "["+fd.itemName+"*"+fd.number+ "]";
}

function displayItemFormula(idOrName){
    var queue=[];
    queue.push(idOrName);
    while(queue.length>0){
        var current=queue.shift();
        var formula = Formula.getItemFormula(current);
        //console.log(current,formula);
        if(!formula){
            continue;
        }
        
        //display inputs
        var str="";
        
        for(var i in formula.inputs){
            var fd=formula.inputs[i];
            if(i!=0){
                str+="+";
            }
            str +=formatFormulaItem(fd);
            queue.push(fd.itemName);
        }
        
        var outputDetail=formula.getOutputItemDetail(current);
        var fatory = Factory.getFactoryOfType(formula.config.factoryType);
        str += "->["+fatory.name+ "]->"+formatFormulaItem(outputDetail);
       console.log(str);
    }
}

function formatItemLine(itemLine){

    var str=itemLine.itemName+":"+itemLine.count;
    if(itemLine.formula){
        str+=",";
        
        var formula=itemLine.formula;
        
        //具体产出信息
        var outputDetail=formula.getOutputItemDetail(itemLine.itemName);

        //工厂信息
        var factory = Factory.getFactoryOfType(formula.config.factoryType);

        var factorySpeedPerSecond=factory.speed/formula.config.useTime;
        var factoryCount=itemLine.count/(outputDetail.number*factorySpeedPerSecond);
        
        str += factory.name +":"+factoryCount+".{";
        
        for(var i in formula.inputs){
            var fd=formula.inputs[i];
            if(i!=0){
                str+="+";
            }
            str +=formatFormulaItem(fd);
        }
        
        str += "->"+formatFormulaItem(outputDetail);
        str+="}"
    }
    return str;
}

function caculateFactoryLines(idOrName,count){
    var queue=[];
    queue.push({item:idOrName,count:count});
   //物品信息
    var itemLines={};
    while(queue.length>0){
        var current=queue.shift();

        //单个物品
        var itemLine=itemLines[current.item];
        if(!itemLine){
            itemLine={
                itemName:current.item,
                count:0,
                formula:Formula.getItemFormula(current.item)
            };
            itemLines[current.item]=itemLine;
        }
        itemLine.count+=current.count;
        var formula = itemLine.formula;
        //console.log(current,formula);
        if(!formula){
            continue;
        }
        
        
        //具体产出信息
        var outputDetail=formula.getOutputItemDetail(current.item);
       
       
        for(var i in formula.inputs){
            var fd=formula.inputs[i];
            queue.push({
                item:fd.itemName,
                count:fd.number*current.count/outputDetail.number
            });
        }
    }
    
    console.log(itemLines);
    
    for(var i in itemLines){
        var s=formatItemLine(itemLines[i]);
        console.log(s);
    }
}
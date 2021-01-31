var fs=require('fs');

function Formula(config){
    this.config=config;
    this.inputs=[];
    this.outputs=[];
}

Formula.Type={
    Input:1,
    Output:2
}

Formula.loadConfig=function (){

    //info
    var cnt=fs.readFileSync("./data/Formula.json");
    var data=JSON.parse(cnt.toString());
    var formulas=[];
    var map={};

    for(var i in data){
        var config=data[i];
        var formula= new Formula(config);
        if(config.id){
            map[config.id]=formula;
        }
        if(config.name){
            map[config.name]=formula;
        }

        formulas.push(formula);
    }
    
    Formula.formulas = formulas;
    Formula.map=map;
    
    //detail
    cnt=fs.readFileSync("./data/FormulaDetails.json");
    data=JSON.parse(cnt.toString());
    
    var items={};
    
    for(var i in data){
        var fd=data[i];
        var formula= null;
        formula = Formula.getFormula(fd.formulaId);
        if(!formula){
            formula = Formula.getFormula(fd.formulaName);
        }

        if(fd.type==Formula.Type.Input){
            formula.inputs.push(fd);
        }
        else if(fd.type==Formula.Type.Output){
            formula.outputs.push(fd);
            var itemFormulas=null;
            if(fd.itemId){
                itemFormulas = items[fd.itemId];
                if(!itemFormulas){
                    itemFormulas=[];
                    items[fd.itemId]=itemFormulas;
                }
                itemFormulas.push(formula);
            }
            
            if(fd.itemName){
                itemFormulas = items[fd.itemName];
                if(!itemFormulas){
                    itemFormulas=[];
                    items[fd.itemName]=itemFormulas;
                }
                itemFormulas.push(formula);
            }
        }
    }
    
    Formula.items=items;
}

Formula.getFormula=function(idOrName){
    return Formula.map[idOrName];
}

Formula.getItemFormula2=function(itemIdOrName){
    for(var i in Formula.formulas){
        var formula=Formula.formulas[i];
        if(formula.haveOutputItem(itemIdOrName)){
            return formula;
        }
    }
    return null;
}

Formula.getItemFormula=function(itemIdOrName){
    var formulas=Formula.items[itemIdOrName];
    if(formulas && formulas.length>0){
        return formulas[0];
    }        
    return null;
}

Formula.getItemFormulas=function(itemIdOrName){
    var formulas=Formula.items[itemIdOrName];
    return formulas;
}

Formula.prototype.haveOutputItem=function(itemIdOrName){
    for(var i in this.outputs){
        var fd=this.outputs[i];
        if(fd.itemId==itemIdOrName || fd.itemName==itemIdOrName){
            return true;
        }
    }
    return false;
}

Formula.prototype.getOutputItemDetail=function(itemIdOrName){
    for(var i in this.outputs){
        var fd=this.outputs[i];
        if(fd.itemId==itemIdOrName || fd.itemName==itemIdOrName){
            return fd;
        }
    }
    return null;
}

module.exports=Formula;
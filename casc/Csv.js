var fs=require('fs');

function Csv(options){
    this.options=options||{};
    this.header=this.options.header;
    this.delimiter=this.options.delimiter||",";
}

Csv.prototype.open=function(filePath){
    this.fp=fs.open(filePath,"+w");    
}

Csv.prototype.close=function(){
    this.fp.close(); 
}

Csv.prototype.readAll=function(){
    
}

Csv.prototype.read=function(row,length){
    
}

Csv.prototype.write=function(data){
    
}

Csv.prototype.writeAll=function(data){
    
}


module.exports=Csv;
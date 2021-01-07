var fs=require('fs');

var CR=13;
var LF=10;

function Csv(options){
    this.options = options||{};
    this.header = this.options.header;
    this.delimiter = this.options.delimiter||",";
    this.encoding = this.options.encoding||"utf8";
    this.readSize =this.options.readSize||1024;
    if(!this.options.bufferSize){
        this.options.bufferSize = 1024*1024;
    }
    this.line = -1;
}

Csv.prototype.createHeader=function(data){
    var header=[];
    for(var k in data){
        if(data.hasOwnProperty(k)){
            var item={name:k};
            item.type=typeof(data[k]);
            header.push(item);
        }
    }
    return header;
}

Csv.prototype.open=function(filePath,flags){
    flags = flags||"r";
    this.fp=fs.openSync(filePath,flags);  
}

Csv.prototype.close=function(){
    fs.closeSync(this.fp); 
}

Csv.prototype.createBuffer=function(){
    this.buffer=Buffer.alloc(this.options.bufferSize);
    this.bufferLength=0;
    this.checkPositon=0;
    this.lineStartPosition=0;
}

Csv.prototype.resizeBuffer=function(){
    var newBuffer=Buffer.alloc(this.buffer.length+this.options.bufferSize);
    this.buffer.copy(newBuffer);
    this.buffer=newBuffer;
}

Csv.prototype.resetBuffer=function(){
    this.bufferLength=0;
    this.checkPositon=0;
    this.lineStartPosition=0;
}

Csv.prototype.readBuffer=function(){
    //检查buffer是否能容纳读取字节数
    if(this.buffer.length-this.bufferLength<this.readSize){
        console.log("then buffer size will full.")
        this.resizeBuffer();
    }
    
    var readLen = fs.readSync(this.fp,this.buffer,this.bufferLength,this.readSize);
    this.bufferLength += readLen;
    return readLen;
}

Csv.prototype.parseBuffer=function(rows,startLine,endLine){
    while(this.checkPositon<this.bufferLength){
        var c = this.buffer[this.checkPositon];
        if(c == LF ){
            ++this.line;
            
            if(endLine>0 && this.line>=endLine){
                return;
            }
            
            if(this.line >= startLine){              
                var BackPos = 0;
                
                if(this.checkPositon>0){
                    if(this.buffer[this.checkPositon-1]== CR ){
                        BackPos+=1;
                    }
                }
      
                var lineStr = this.buffer.toString(this.encoding,this.lineStartPosition,this.checkPositon-BackPos);
                if(lineStr){
                    var rowData = this.parseLine(lineStr);
                    if(rows){
                        rows.push(rowData);
                    }
                }
            }

            //next char
            this.lineStartPosition = this.checkPositon + 1;
            //继续检查
        }
        ++this.checkPositon;
    }
    
    //移除检查过的行。
    if(this.lineStartPosition < this.bufferLength){
        this.buffer.copy(this.buffer,0,this.lineStartPosition,this.bufferLength);
        this.bufferLength -= this.lineStartPosition;
        this.lineStartPosition = 0;
        this.checkPositon = this.bufferLength;
    }else{
        // empty
        this.bufferLength = 0;
        this.checkPositon = 0;
        this.lineStartPosition = 0;
    }
}

Csv.prototype.parseLastBuffer=function(rows,startLine,endLine){
    if(this.bufferLength > 0){
        ++this.line;
        if(endLine>0 && this.line>=endLine){
            return;
        }
        if(this.line >= startLine){
            var line = this.buffer.toString(this.encoding,this.lineStartPosition,this.checkPositon);
            if(line){
                var rowData = this.parseLine(line);
                if(rows){
                    rows.push(rowData);
                }
            }
        }
    }
}

Csv.prototype.parseLine=function(line){
    var values = line.split(this.delimiter);
    //console.log(values);
    var data={};
    for(var i=0;i<this.header.length && i< values.length;++i){
        var col=this.header[i];
        var v =values[i].trim();
        switch(col.type){
            case "int":
                v=parseInt(v);
                break;
            case "float":
                v=parseFloat(v);
                break;
        }
        //console.log(col.name,v);
        data[col.name]=v;
    }
    return data;
}

Csv.prototype.readLines=function(start,end){
    var rows=[];
    
    if(this.bufferLength>0){
        this.parseBuffer(rows,start,end);
    }
    
    while(this.line>=start && (end<=0 || this.line<end)){
        if(this.readBuffer()==0){
            //eof
            this.parseLastBuffer(rows,start,end);
            break;
        }else{
            this.parseBuffer(rows,start,end);
        }
    }
    return rows;
}

Csv.prototype.readAll=function(filePath){
    var rows=[];
    this.open(filePath,"r+");
    try{
        this.line = -1;
        this.createBuffer();
        while(true){
            if(this.readBuffer()==0){
                //eof
                this.parseLastBuffer(rows,0,-1);
                break;
            }else{
                this.parseBuffer(rows,0,-1);
            }
        }
    }catch(e){
       throw e; 
    }
    finally{
        this.close();
    }
    return rows;
}

Csv.prototype.write=function(data){
    if(!this.fp){
        return;
    }
    
    for(var i=0;i<this.header.length;++i){
        var colName=this.header[i].name;
        if(i>0){
            fs.writeSync(this.fp,this.delimiter);
        }
        fs.writeSync(this.fp,data[colName]);
    }
    fs.writeSync(this.fp,"\n");
}

Csv.prototype.writeAll=function(filePath,arr){
    this.open(filePath,"w+");
    try{
        if(!this.header || this.header.length==0){
            this.header=this.createHeader(arr[0]);
        }
        for(var i in arr){
            this.write(arr[i]);
        }
    }catch(e){
       throw e; 
    }
    finally{
        this.close();
    }
}

module.exports=Csv;
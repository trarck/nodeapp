var fs=require('fs')
var path=require('path')

function IndexFile(){
    
}

IndexFile.readIdxEntiesFromFile=function(idxFile){
    var cnt=fs.readFileSync(idxFile);
    var offset=0;
    var headLength = cnt.readUInt32LE(offset);
    offset+=4;
    var headHash = cnt.readUInt32LE(offset);
    offset+=4;
    
    var indexVersion = cnt.readUInt16LE(offset);
    offset+=2;
    var bucketIndex = cnt.readUInt8(offset);
    offset+=2;
    
    var encodedSizeLength = cnt.readUInt8(offset);
    offset+=1;
    var storageOffsetLength = cnt.readUInt8(offset);
    offset+=1;
    var eKeyLength = cnt.readUInt8(offset);
    offset+=1;
    
    var fileOffsetBits = cnt.readUInt8(offset);
    offset+=1;
    var segmentSize = cnt.readBigUInt64BE(offset);
    offset+=8;
    /*
    console.log("indexVersion="+indexVersion,
        "bucketIndex="+bucketIndex,
        "encodedSizeLength="+encodedSizeLength,
        "storageOffsetLength="+storageOffsetLength,
        "eKeyLength="+eKeyLength,
        "fileOffsetBits="+fileOffsetBits,
        "segmentSize="+segmentSize);
        */
    //pad 8
    offset+=8;

    var dataLength = cnt.readUInt32LE(offset);
    offset+=4;
    var dataCheck = cnt.readUInt32LE(offset);
    offset+=4;
    
    //console.log(dataLength,dataCheck,dataLength/18);
    var entryLen=dataLength/18;
    var entries=[]
    for(var i=0;i<entryLen;++i){
        var entry={};
        
        entry.key=bytesToHex(cnt,offset,9);
        offset+=9;
        var h=cnt.readUInt8(offset);
        offset+=1;
        var l=cnt.readUInt32BE(offset);
        offset+=4;
        
        entry.index= h << 2 | ( (l& 0xC0000000) >>> 30);
        entry.offset=l & 0x3FFFFFFF;
        entry.size = cnt.readUInt32LE(offset);
        offset+=4;
        entries.push(entry);
    }
    
    if(entries.length!=entryLen){
        console.log("the entries length not match need="+entryLen+",read="+entries.length);
    }
    return entries;
}

IndexFile.getIdxInfo=function(filePath){
    var nameWithOutExt=path.basename(filePath,path.extname(filePath));
    var type=parseInt(nameWithOutExt.substr(0,2),16);
    var version = parseInt(nameWithOutExt.substr(2),16);
    return {type:type,version:version,file:filePath};
}

IndexFile.getFileName=function(idxInfo){
    return byteToHex(idxInfo.type)+intToHex(idxInfo.version);
}


function intToHex(v){
    return byteToHex(v>>24)+byteToHex((v&0xFF0000) >>16)+byteToHex((v&0xFF00) >>8)+byteToHex(v&0xFF);
}

function bytesToHex(buff,offset,length){
    var offset= typeof(offset)=="undefined"?0:offset;
    var length = typeof(length)=="undefined"?buff.length:length;
    var strArr=[];
    var end=offset+length;
    if(end>buff.length){
        end=buff.length;
    }
    
    for(var i=offset;i<end;++i){
        strArr.push(byteToHex(buff[i]))
    }
    return strArr.join("");
}

function byteToHex(v){
    if(v<16){
        return "0"+v.toString(16);
    }else{
        return v.toString(16);
    }
}

exports.IndexFile=IndexFile;
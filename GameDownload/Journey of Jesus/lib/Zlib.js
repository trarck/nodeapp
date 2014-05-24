
var zlib=require("zlib");

var buf=new Buffer(11);

exports.Zlib={
    uncompress:function(bytes,callback){
        var cmf=bytes[0];
        var cinfo=cmf>>4;
        var cm=cmf & 0xF; 
        
        var flg=bytes[1];

        var fcheck=flg & 0x1F;
        var fdict=(flg & 0x20) >>5;
        var flevel=flg >>6;
        
        var offset=2;
        if(fdict){
            var presetDictionary=bytes.slice(2,6);
            offset+=4;
        }

        console.log("cinfo="+cinfo+",cm="+cm+",fcheck="+fcheck+",fdict="+fdict+",flevel="+flevel+",offset="+offset);

        
        var compressedData=bytes.slice(offset,bytes.length-4);

        var uncompressedDict=bytes.slice(bytes.length-4);
        
        zlib.inflate(compressedData,function(err,data){
            callback(err,data);
        });
        return true;
    }
};
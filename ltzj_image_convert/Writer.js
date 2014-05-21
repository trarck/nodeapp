var fs=require("fs");
var OutputStream=require("./OutputStream").OutputStream;


function Writer(buffer)
{
	this._stream=new OutputStream(buffer);
}

Writer.prototype={
	
	/*[
		    index,
		    itemId,itemName,num11,fromLevel,toLevel,
		    type,description,icon,num21,num22,num23,num24,//12
		    str01,num31,
		    level1,level2,
		    num41,num42,								//18
			num51,base,up,num52,						//22
			animationData,animationImage,bulletAnimationData,bulletAnimationImage,//26
			num61,num62,num63,num64,					//30
			baozhou,skillName
		];
	*/
	writeEngineRecord:function(record){
		
		var stream=this._stream;
					
		//index
		stream.writeUInt16BE(record[0]);
		//itemId
		stream.writeUInt16BE(record[1]);
		//itemName
		this.writeString(record[2]);
		stream.writeUInt8(record[3]);
		//fromLevel
		stream.writeUInt16BE(record[4]);	
		//toLevel
        stream.writeUInt16BE(record[5]);	
		//type
		this.writeString(record[6]);
		//description
		this.writeString(record[7]);
		//icon			
		this.writeString(record[8]);
		//num21--num24
		stream.writeFloatBE(record[9]);
		stream.writeFloatBE(record[10]);
		stream.writeFloatBE(record[11]);
		stream.writeFloatBE(record[12]);
		//str01
		this.writeString(record[13]);
		//num31
	    stream.writeUInt16BE(record[14]);
		//level1,level2
		stream.writeFloatBE(record[15]);
		stream.writeFloatBE(record[16]);		
		//num41,num42
		stream.writeFloatBE(record[17]);
		stream.writeFloatBE(record[18]);
	
		//num51
		stream.writeUInt32BE(record[19]);
		//base
		stream.writeFloatBE(record[20]);
		//up
		stream.writeFloatBE(record[21]);
		//num52
		stream.writeUInt32BE(record[22]);
		//animationData
		this.writeString(record[23]);
		//animationImage
		this.writeString(record[24]);
		//bulletAnimationData
		this.writeString(record[25]);
		//bulletAnimationImage
		this.writeString(record[26]);

		//num61
		stream.writeUInt32BE(record[27]);
		//num62
		stream.writeUInt8(record[28]);
		//num63
		stream.writeFloatBE(record[29]);
		//num64
		stream.writeFloatBE(record[30]);
		
		//baozhou
		this.writeString(record[31]);
					
		//skillName
		this.writeString(record[32]);
	},
	
	writeEngineConfig:function(config){
		
		var stream=this._stream;
		//version
		stream.writeUInt32BE(config.header.version);
		//nouse
		stream.writeUInt32BE(config.header.nouse);		
		//count
		stream.writeUInt16BE(config.header.count);
		
		var data=config.data;
		
		for (var i = 0; i < data.length; i++) {
			this.writeEngineRecord(data[i]);
		}
	},
	
	writeString:function(str){
		
		var stream=this._stream;

		var strLen=Buffer.byteLength(str);
		
		stream.writeUInt16BE(strLen);
	
		stream.writeBytes(str,strLen);
		
	},
	
	saveTo:function(filepath){
		fs.writeFileSync(filepath,this._stream.getRealBuffer());
	}
};

exports.Writer=Writer;
var InputStream=require("./InputStream").InputStream;

function Reader(buffer)
{
	this._stream=new InputStream(buffer);
}

Reader.prototype={
	
	readHeader:function(){
		
		var stream=this._stream;
		
		var version=stream.readUInt32BE();
	
		var nouse=stream.readUInt32BE();
	
		//record count
		var count=stream.readUInt16BE();
	
        return {
			version:version,
			nouse:nouse,
			count:count
		};
	},
	
	readArmorRecord:function(){
		var stream=this.stream;
		
		var index=stream.readUInt16BE();
	
		var itemId=stream.readUInt16BE();
		var itemName=this.readString();
	
		var num11=stream.readUInt8();
		var fromLevel=stream.readUInt16BE();//开始等级
        var toLevel=stream.readUInt16BE();//结束等级
		var num14=stream.readUInt16BE();
	
		var description=this.readString();
		
		var icon=this.readString();

		var num21=stream.readFloatBE();
		var num22=stream.readFloatBE();
		var num23=stream.readFloatBE();
		var num24=stream.readFloatBE();
	
		var str01=this.readString();

	    var num31=stream.readUInt16BE();

		var level1=stream.readFloatBE();
		var level2=stream.readFloatBE();		
	
		var num41=stream.readFloatBE();
		var num42=stream.readFloatBE();
	
		var startHP=stream.readFloatBE();
		var addHP1=stream.readFloatBE();
		var addHP2=stream.readFloatBE();
		var rat=stream.readFloatBE();
	
		var num51=stream.readFloatBE();
	
		var funType=this.readString();
		var funPam=this.readString();
	
		var str11=this.readString();
		var str12=this.readString();
	
		var skillName=this.readString();
	
		return [
            index,
            itemId,itemName,num11,fromLevel,toLevel,num14,
            description,icon,num21,num22,num23,num24,
            str01,num31,
            level1,level2,
            num41,num42,
            startHP,addHP1,addHP2,rat,num51,
            funType,funPam,str11,str12,skillName
        ];
	},
	
	readArmorConfig:function(){
		
		var header=this.readHeader();
		
		var data=[];
		
        var record;
		
		var count=header.count;
		
		var i=0;

		while( i++< count && !this._stream.eof()){

			record=this.readArmorRecord();

	        data.push(record);
		}
		
        return {
			header:header,
			data:data
		};
	},
	
	readWeaponRecord:function(){
		
		var stream=this._stream;
		
		var index=stream.readUInt16BE();
	
		var itemId=stream.readUInt16BE();
		var itemName=this.readString();
	
		var num11=stream.readUInt8();
		var fromLevel=stream.readUInt16BE();//开始等级
        var toLevel=stream.readUInt16BE();//结束等级
		var num14=stream.readUInt16BE();
	
		var description=this.readString();
		var icon=this.readString();

		var num21=stream.readFloatBE();
		var num22=stream.readFloatBE();
		var num23=stream.readFloatBE();
		var num24=stream.readFloatBE();
	
		var str01=this.readString();

	    var num31=stream.readUInt16BE();

		var level1=stream.readFloatBE();
		var level2=stream.readFloatBE();		
	
		var num41=stream.readFloatBE();
		var num42=stream.readFloatBE();
	
		var num51=stream.readUInt32BE();
		var baseAttack=stream.readFloatBE();
		var upAttack=stream.readFloatBE();
		var num52=stream.readUInt32BE();
			
		var skillName=this.readString();
	

		return [
            index,
            itemId,itemName,num11,fromLevel,toLevel,num14,
            description,icon,num21,num22,num23,num24,
            str01,num31,
            level1,level2,
            num41,num42,
			num51,baseAttack,upAttack,num52,
			skillName
        ];
	},
	
	readWeaponConfig:function(){
		
		var header=this.readHeader();
		
		var data=[];
		
        var record;

		while(!this._stream.eof()){

			record=this.readWeaponRecord();

	        data.push(record);
		}
		
        return {
			header:header,
			data:data
		};
	},
	
	readWingmanRecord:function(){
		
		var stream=this._stream;
		
		var index=stream.readUInt16BE();
	
		var itemId=stream.readUInt16BE();
		var itemName=this.readString();
	
	
		var num11=stream.readUInt8();
		var fromLevel=stream.readUInt16BE();//开始等级
        var toLevel=stream.readUInt16BE();//结束等级
		var num14=stream.readUInt16BE();
	
		var description=this.readString();
		var icon=this.readString();

		var num21=stream.readFloatBE();
		var num22=stream.readFloatBE();
		var num23=stream.readFloatBE();
		var num24=stream.readFloatBE();
	
		var str01=this.readString();

	    var num31=stream.readUInt16BE();

		var level1=stream.readFloatBE();
		var level2=stream.readFloatBE();		
	
		var num41=stream.readFloatBE();
		var num42=stream.readFloatBE();
	
		var num51=stream.readUInt32BE();
		var baseAttack=stream.readFloatBE();
		var upAttack=stream.readFloatBE();
		var num52=stream.readUInt32BE();
	
		var animation=this.readString();
	
		var weaponStr=this.readString();
	
		var num61=stream.readFloatBE();
		var num62=stream.readFloatBE();
		var num63=stream.readFloatBE();
		var num64=stream.readFloatBE();
		
		var num71=stream.readUInt16BE();
		
		var skillName=this.readString();
	
		return [
		    index,
		    itemId,itemName,num11,fromLevel,toLevel,num14,
		    description,icon,num21,num22,num23,num24,
		    str01,num31,
		    level1,level2,
		    num41,num42,
			num51,baseAttack,upAttack,num52,
			animation,weaponStr,
			num61,num62,num63,num64,
			num71,skillName
		];
		
	},
	readWingmanConfig:function(){
		
		var header=this.readHeader();
		
		var data=[];

        var record;

		while(!this._stream.eof()){

			record=this.readWingmanRecord();

	        data.push(record);
		}

        return {
			header:header,
			data:data
		};
	},
	
	readEngineRecord:function(){
		
		var stream=this._stream;
		
		var index=stream.readUInt16BE();
	
		var itemId=stream.readUInt16BE();
		var itemName=this.readString();

		var num11=stream.readUInt8();
		var fromLevel=stream.readUInt16BE();//开始等级
        var toLevel=stream.readUInt16BE();//结束等级		
	
		var type=this.readString();
	
		var description=this.readString();
					
		var icon=this.readString();

		var num21=stream.readFloatBE();
		var num22=stream.readFloatBE();
		var num23=stream.readFloatBE();
		var num24=stream.readFloatBE();
	
		var str01=this.readString();

	    var num31=stream.readUInt16BE();

		var level1=stream.readFloatBE();
		var level2=stream.readFloatBE();		
		
		var num41=stream.readFloatBE();
		var num42=stream.readFloatBE();
	
		var num51=stream.readUInt32BE();
		var base=stream.readFloatBE();
		var up=stream.readFloatBE();
		var num52=stream.readUInt32BE();
				
	
		var animationData=this.readString();
		var animationImage=this.readString();
		var bulletAnimationData=this.readString();
		var bulletAnimationImage=this.readString();

		var num61=stream.readUInt32BE();
		var num62=stream.readUInt8();
		var num63=stream.readFloatBE();
		var num64=stream.readFloatBE();
		
		var baozhou=this.readString();
					
		var skillName=this.readString();
	
		return [
		    index,
		    itemId,itemName,num11,fromLevel,toLevel,//5
		    type,description,						//7
			icon,num21,num22,num23,num24,			//11
		    str01,num31,
		    level1,level2,							//15
		    num41,num42,
			num51,base,up,num52,					//20
			animationData,animationImage,bulletAnimationData,bulletAnimationImage,//24
			num61,num62,num63,num64,				//28
			baozhou,skillName						//32
		];
	},
	
	readEngineConfig:function(){
		
		var header=this.readHeader();
		
		var data=[];

        var record;

		while(!this._stream.eof()){

			record=this.readEngineRecord();

	        data.push(record);
		}

        return {
			header:header,
			data:data
		};
	},
	
	readLootRecord:function(){
		var stream=this._stream;
		
		var index=stream.readUInt16BE();
		var itemId=stream.readUInt16BE();
		var itemName=this.readString();
		
		//skip 5 byte
		stream.seek(5);
		var desc=this.readString();
		
		var num11=stream.readUInt16BE();
		
		var str1=this.readString();
		var str2=this.readString();
		var str3=this.readString();
		
		var num21=stream.readUInt16BE(); 
		var num22=stream.readUInt32BE();
		
        return [
			index,
			itemId,itemName,
			desc,num11,
			str1,str2,str3,
			num21,num22
		];
		
	},
	
	readLootConfig:function(){
		
		var header=this.readHeader();
		
		var data=[];

        var record;

		while(!this._stream.eof()){

			record=this.readLootRecord();

	        data.push(record);
		}

        return {
			header:header,
			data:data
		};
	},
	
	readString:function(){
		
		var strLength=this._stream.readUInt16BE();
		
		var strBuf=this._stream.readBytes(strLength);
		
		return strBuf.toString("utf8");
	}
	
};

exports.Reader=Reader;
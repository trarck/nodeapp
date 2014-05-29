var OutputStream= function(buffer) {
    
	if (typeof(buffer)=="number") {
		//buffer is size
		this.body=new Buffer(buffer);
	}else{
		//buffer is object
		this.body=buffer;
	}
		
    this.offset=0;
    this.bitOffset=0;
};

OutputStream.prototype= {
    /**
     * 按字节顺序读取
     * @param length
     */
    writeBytes: function(bytes,length) {
		this.checkWriteable(length);
  	 	var len=this.body.write(bytes,this.offset,length);
		this.offset+=len;
    },
	
    //readByte||readUI8
    writeByte: function(val) {
		this.checkWriteable(1);
        this.body[this.offset++]= val && 0xFF;
    },
	
	writeUInt8 :function(value){
		this.checkWriteable(1);
		this.body.writeUInt8(value,this.offset++);
	},
	writeUInt16LE:function(value){
		this.checkWriteable(2);
		this.body.writeUInt16LE(value,this.offset);
		this.offset+=2;
	},
	writeUInt16BE:function(value){
		this.checkWriteable(2);
		this.body.writeUInt16BE(value,this.offset);
		this.offset+=2;
	},
	writeUInt32LE:function(value){
		this.checkWriteable(4);
		this.body.writeUInt32LE(value,this.offset);
		this.offset+=4;
	},
	writeUInt32BE:function(value){
		this.checkWriteable(4);
		this.body.writeUInt32BE(value,this.offset);
		this.offset+=4;
	},
	writeInt8:function(value){
		this.checkWriteable(1);
		this.body.writeInt8(value,this.offset++);
	},
	writeInt16LE:function(value){
		this.checkWriteable(2);
		this.body.writeInt16LE(value,this.offset);
		this.offset+=2;
	},
	writeInt16BE:function(value){
		this.checkWriteable(2);
		this.body.writeInt16BE(value,this.offset);
		this.offset+=2;
	},
	writeInt32LE:function(value){
		this.checkWriteable(4);
		this.body.writeInt32LE(value,this.offset);
		this.offset+=4;
	},
	writeInt32BE:function(value){
		this.checkWriteable(4);
		this.body.writeInt32BE(value,this.offset);
		this.offset+=4;
	},
	writeFloatLE:function(value){
		this.checkWriteable(4);
		this.body.writeFloatLE(value,this.offset);
		this.offset+=4;
	},
	writeFloatBE:function(value){
		this.checkWriteable(4);
		this.body.writeFloatBE(value,this.offset);
		this.offset+=4;
	},
	writeDoubleLE:function(value){
		this.checkWriteable(8);
		this.body.writeDoubleLE(value,this.offset);
		this.offset+=8;
	},
	writeDoubleBE:function(value){
		this.checkWriteable(8);
		this.body.writeDoubleBE(value,this.offset);
		this.offset+=8;
	},

    //readFloat16
    // writeFloat16: function() {
    //     var cnt=this.readBits(16);
    //     this.align();
    //     var s=(cnt>>>15)&0x1;
    //     var exp=(cnt>>>10)&0x1F;
    //     var fraction=cnt&0x3FF;
    //     return(s==0?1:-1)*(fraction/Math.pow(2,10)+1)*Math.pow(2,exp-16);
    // },
    // 	
    // //readFloat
    // readFloat: function() {
    //     var cnt=this.readNumber(4,false);
    //     this.align();
    //     var s=(cnt>>>31)&0x1;
    //     var exp=(cnt>>>23)&0xFF;
    //     var fraction=cnt&0x7FFFFF;
    //     if(exp==255) {
    //         if(fraction==0) {
    //             return s==0?Number.POSITIVE_INFINITY:Number.NEGATIVE_INFINITY;
    //         } else {
    //             return Number.NaN;
    //         }
    //     } else if(exp==0&&fraction==0) {
    //         return(0);
    //     }
    //     return(s==0?1:-1)*(fraction/Math.pow(2,23)+1)*Math.pow(2,exp-127);
    // },
    // //readDouble,前4位是高位，后4位是底位。
    // //每4位是little-endian
    // readDouble: function() {
    //     var high=this.readNumber(4,false);
    //     var low=this.readNumber(4,false);
    //     this.align();
    //     var s=high>>>31&0x1;
    //     var exp=high>>>20&0x7FF;
    //     var manHigh=high&0xFFFFF;
    //     return(s==0?1:-1)*(manHigh/Math.pow(2,20)+low/Math.pow(2,52)+1)*Math.pow(2,exp-1023);
    // },

    // readFixedPoint: function(numBits, precision){
    //     return this.readBits(numBits) * Math.pow(2, -precision);//高底位没有转换
    // },
    // 
    // readFixed8: function(){
    //     return this.readWord()/0x100;//this.readFixedPoint(16, 8);
    // },
    // 
    // readFixed: function(){
    //     return this.readNumber(4)/0x10000;//this.readFixedPoint(32, 16);
    // },
		
    //getBuffer
    getBuffer: function() {
        return this.body;
    },
    //getBufferLength
    getBufferLength: function() {
        return this.body.length;
    },
    //getOffset
    getOffset: function() {
        return this.offset;
    },
    //getBitOffset
    getBitOffset: function() {
        return this.bitOffset;
    },
    //align read bit end
    align: function(bits) {
        var residual=this.bitOffset&0x7;//是否移动了8的倍数，如果不是，则要多移动一个字节，这个字节后面的内容无意义。
        this.offset+=Math.floor(this.bitOffset/8)+(residual!=0?1:0);
        this.bitOffset=0;
    },
    //seek
    seek: function(length) {
        this.offset+=length;
    },
    //reset
    reset: function(offset,bitOffset) {
        this.offset=offset;
        this.bitOffset=bitOffset;
    },
    //eof
    eof: function() {
        return this.offset>=this.body.length;
    },
	
	//是否可写，size要写入的大小
	isWriteable:function(size){
		return this.offset+size<=this.body.length;
	},
	
	checkWriteable:function(size){
		if (!this.isWriteable(size)) {
			this.enlarge();
		}
	},
	
	//扩大
	enlarge:function(size){
		if(!size) {
			size=this.body.length*0.25;
		}
		
		var newBuffer=new Buffer(this.body.length+size);
		this.body.copy(newBuffer);
		this.body=newBuffer;
	},
	
	getRealBuffer:function(){
		
		if (this.offset==this.body.length) {
			return this.body;
		}else{
			return this.body.slice(0,this.offset);
		}
	},
	
    //unsigned to signed
    UtoS:function(num,numBits) {
        if((num&(1<<(numBits-1)))!=0) {
            return num-(1<<numBits);
        }
        return num;
    }
};

exports.OutputStream=OutputStream;

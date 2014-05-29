var InputStream= function(buffer) {
    
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

InputStream.prototype= {

    /**
     * 读取一位
     */
    readBit: function() {
        var v=(this.body[this.offset+(this.bitOffset>>3)]>>(7-(this.bitOffset&0x7)))&1;
        this.bitOffset++;
        return v;
    },
    //readBool
    readBool: function() {
        return this.readBit();
    },

    /**
     * 读取位
     * @param length
     */
    readBits: function(length) {
        var v=this.getBits(length);
        this.bitOffset+=length;
        return v;
    },
    /**
     * 读取位，但不改变位指针
     * @param length
     */
    getBits: function(length) {
        if(length==0)
            return(0);
        var begin=this.offset*8+this.bitOffset;
        var end=begin+length;
        var byteBeginIndex=begin>>3; // Byte boundary including start point
        var beginBitOffset=begin&0x7; // Number of bits from byteBeginIndex to start point
        var byteEndIndex=end>>3;// Byte boundary including end point
        var endBitOffset=end&0x7;// Number of bits from byteEndIndex until end point

        // TODO buffer over flow check

        if(byteBeginIndex==byteEndIndex) {
            return(this.body[byteBeginIndex]>>(8-endBitOffset))&((1<<length)-1);
        } else {
            var ret=this.body[byteBeginIndex]&(0xFF>>beginBitOffset);
            for(var i=byteBeginIndex+1;i<byteEndIndex;i++) {
                ret=(ret<<8)+(this.body[i]&0xFF);
            }
            if(endBitOffset==0) {
                return ret;
            } else {
                return(ret<<endBitOffset)+((this.body[byteEndIndex]&0xFF)>>(8-endBitOffset));
            }
        }
    },
	
    /**
     * 带符号的位数字,位数与扩展的数的位数相等
     * @param length
     */
    readSBits:function (length) {
        return this.UtoS(this.readBits(length),length);
    },
    /**
     * 带符号的位数字
     * @param length
     * @param ext 位数
     */
    readSBitsExt:function (length,ext) {
        return this.UtoS(this.readBits(length),ext);
    },
    /**
     * 按字节顺序读取
     * @param length
     */
    readBytes: function(length) {
        this.align();
        if(length==null) {
            var pos=this.offset;
            for(var i=1;this.body[this.offset++]!=0;i++) {}
            return this.body.slice(pos,pos+i);
        } else {
            var bytes=this.body.slice(this.offset,this.offset+length);
            this.seek(length);
            return bytes;
        }
    },
	
    //readByte||readUI8
    readByte: function() {
        return this.body[this.offset++];
    },
	
    //getByte||getUI8
    getByte: function() {
        this.align();
        return this.body[this.offset];
    },
	
    //readNumber
    readNumber: function(length,signed) {
        this.align();
        var n=0;
        for(var i=0;i<length;i++) {
            n|=(this.body[this.offset+i]&0xFF)<<(i*8);
        }
        this.seek(length);
        if(signed&&((0x80<<((length-1)*8))&n)!=0) {
            n|=(-1)<<(length*8);
        }
        return n;
    },
    //getNumber
    getNumber: function(length) {
        this.align();
        var n=0;
        for(var i=0;i<length;i++) {
            n|=(this.body[this.offset+i]&0xFF)<<(i*8);
        }
        return n;
    },
	
	readUInt8:function(){
		return this.body.readUInt8(this.offset++);
	},
	
	readUInt16LE:function(){
		var ret=this.body.readUInt16LE(this.offset);
		this.offset+=2;
		return ret;
	},
	
	readUInt16BE:function(){
		var ret=this.body.readUInt16BE(this.offset);
		this.offset+=2;
		return ret;
	},
	
	readUInt32LE:function(){
		var ret=this.body.readUInt32LE(this.offset);
		this.offset+=4;
		return ret;
	},
	
	readUInt32BE:function(){
		var ret=this.body.readUInt32BE(this.offset);
		this.offset+=4;
		return ret;
	},
	
	readInt8:function(){
		return this.body.readInt8(this.offset++);
	},
	
	readInt16LE:function(){
		var ret=this.body.readInt16LE(this.offset);
		this.offset+=2;
		return ret;
	},
	
	readInt16BE:function(){
		var ret=this.body.readInt16BE(this.offset);
		this.offset+=2;
		return ret;
	},
	
	readInt32LE:function(){
		var ret=this.body.readInt32LE(this.offset);
		this.offset+=4;
		return ret;
	},
	
	readInt32BE:function(){
		var ret=this.body.readInt32BE(this.offset);
		this.offset+=4;
		return ret;
	},
		
    //readWord||readUI16
    readWord: function() {
        return this.body[this.offset++]+(this.body[this.offset++]<<8);
    },

    //readFloat16
    readFloat16: function() {
        var cnt=this.readBits(16);
        this.align();
        var s=(cnt>>>15)&0x1;
        var exp=(cnt>>>10)&0x1F;
        var fraction=cnt&0x3FF;
        return(s==0?1:-1)*(fraction/Math.pow(2,10)+1)*Math.pow(2,exp-16);
    },
	readFloatLE:function(){
		var ret=this.body.readFloatLE(this.offset);
		this.offset+=4;
		return ret;
	},
	
	readFloatBE:function(){
		var ret=this.body.readFloatBE(this.offset);
		this.offset+=4;
		return ret;
	},
	
	readDoubleLE:function(){
		var ret=this.body.readDoubleLE(this.offset);
		this.offset+=8;
		return ret;
	},
	
	readDoubleBE:function(){
		var ret=this.body.readDoubleBE(this.offset);
		this.offset+=8;
		return ret;
	},
	
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

    readFixedPoint: function(numBits, precision){
        return this.readBits(numBits) * Math.pow(2, -precision);//高底位没有转换
    },

    readFixed8: function(){
        return this.readWord()/0x100;//this.readFixedPoint(16, 8);
    },

    readFixed: function(){
        return this.readNumber(4)/0x10000;//this.readFixedPoint(32, 16);
    },
	
	readString:function(encoding,length){
		return this.body.toString(encoding,this.offset,this.offset+length);
	},
	
    //readRect
    readRect:function () {
        var numBits=this.readBits(5);
        var xMin=this.UtoS(this.readBits(numBits),numBits);
        var xMax=this.UtoS(this.readBits((numBits)),numBits);
        var yMin=this.UtoS(this.readBits(numBits),numBits);
        var yMax=this.UtoS(this.readBits(numBits),numBits);
        return [xMin,yMin,xMax,yMax];
    },
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
    //unsigned to signed
    UtoS:function(num,numBits) {
        if((num&(1<<(numBits-1)))!=0) {
            return num-(1<<numBits);
        }
        return num;
    }
};

exports.InputStream=InputStream;

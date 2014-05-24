// var a="0300020700513DFB6A39C20419D0168D159A6A-05BF-09EF-3BBB-13FF5B88847E";
// var c="0*3 *0*0*0*2*0*7 *0*0*5*1 *3 *D *F *B *6 *A *3 *9 *C *2*0*4 *1 *9 *D *0*1 *6 *8 *D *1 *5*9 *A *6 *A *-*0*5*B *F *-*0*9 *E *F *-*3 *B *B *B *-*1 *3 *F *F *5*B *8 *8 *8 *4 *7 *E*";
// var b="7*47*7*7*7*8*7*24*7*7*2*36*47*11*23*25*26*58*47*21*22*8*7*62*36*21*11*7*36*26*28*11*36*2*21*58*26*58*3*7*2*25*23*3*7*21*49*23*3*47*25*25*25*3*36*47*23*23*2*25*28*28*28*62*24*49*"
// console.log(a.length);
var fs=require("fs");
var yhnode=require("yhnode");

var Download=yhnode.network.Download;
var XMLHttpRequest=yhnode.network.http.XMLHttpRequest;
var WorkPool=require("./lib/WorkPool").WorkPool;

function RandomProxy(seed){
	this._seed=seed;

	this._createMixString();
}

RandomProxy.prototype._createMixString=function () {
	var seed=this._seed;
		
	var mixed ="";
	var source ="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/\\:._-1234567890";
	var index, len = source.length;
	for (var i = 0; i < len; ++i) {
		seed = (seed * 211 + 30031) % 65536;
		index =Math.floor(seed / 65536 *source.length);
		mixed+=source.charAt(index);
		source=source.split(source.charAt(index)).join("");
	}
	this._mixedString=mixed.toString();
};

RandomProxy.prototype.toFileId=function(file){
	var indexs = file.split("*");
	var fileId="";
	for(var i=0,l=indexs.length;i<l;i++){
		fileId+=this._mixedString.charAt(indexs[i]);
	}
	return fileId;
	
};

function Youku(videoId){
	
	this._dataUrl="http://api.youku.com/player/getPlayList";//"/VideoIDS/XNTI1Mzk0OTUy/timezone/+08/version/5/source/out?password=&n=3&ran=9722"
	this._streamPath="http://f.youku.com/player/getFlvPath";
	this._localSavePath="./vedio/";
	
	this._videoId=videoId;
}

Youku.prototype={
	
	start:function(fileType,cb){
		var self=this;
		//get video config data
		this.getPlayerData(this._videoId,function(data){
			self._playListData=JSON.parse(data.toString());
			data=self._playListData.data[0];
			self.downloadVideo(data,fileType,cb);
		});	
	},
	
	downloadVideo:function(configData,fileType,cb){

		var streamfileids=configData.streamfileids[fileType];
		var fileId=this.getFileId(streamfileids,configData.seed);
		
		var segs=configData.segs[fileType];
		var wp=new WorkPool(2);
		
		for(var i=0,l=segs.length;i<l;i++){
			var seg=segs[i];
			
			var srcPath=this._streamPath+this.getFileParameters(seg,fileType,fileId);
			var saveTo=this._localSavePath+this._videoId+"/"+(seg.no.toString())+"."+fileType;
			console.log("srcPath:",srcPath)
			
			wp.add(handleDownload,null,srcPath,saveTo);
		}
		cb && wp.join(cb);
	},
	
	getPlayerData:function(videoId,cb){
		var url=this._dataUrl+"/VideoIDS/"+videoId+"/timezone/08/version/5/source/out?password=&n=3&ran="+(parseInt(Math.random()*9000)+1000);
		var xhr=new XMLHttpRequest();
		xhr.onreadystatechange = function() {
		    if (this.readyState == 4) {
		        cb(this.responseText);
		    }
		};

		xhr.open("GET", url);
		xhr.send();
	},
	
	getFileParameters:function(seg,fileType,fileId){
		var segFileId=this.formateFileIdWithSegIndex(fileId,seg.no);
		console.log("segFileId:",segFileId);
		
		var parameter="";
		var segIndex=seg.no.toString().length==1?"0"+seg.no:seg.no;
		
        parameter += ("/sid/" + this.getSid() + "_" + segIndex);
        parameter += ("/st/" + (fileType == "hd2" || fileType == "hd3" ? "flv" : fileType));
        parameter += ("/fileid/" + segFileId);
		parameter += "?K="+seg.k;
		switch(fileType){
			case "flv":
			case "flvhd":
				parameter+="&hd=0";
			break;
			case "mp4":
				parameter+="&hd=1";
			break;
			case "hd2":
				parameter+="&hd=2";
			break;
			case "hd3":
				parameter+="&hd=3";
			break;
				
		}
		parameter+="&myp=0";
		parameter+="&ts="+seg.seconds;
		parameter+="&ypp=0";
		return parameter;
	},
	
	getSid:function (){
		return new Date().getTime() + "" + (1000 + new Date().getMilliseconds()) + "" + (parseInt(Math.random() * 9000) + 1000);
	},
	
	getFileId:function (file,seed){
		var random=new RandomProxy(seed);
		return fileId=random.toFileId(file);
	},
	
	getFileIdWithSegIndex:function (file,segIndex,seed){
		var random=new RandomProxy(seed);
		var fileId=random.toFileId(file);
		return this.formateFileIdWithSegIndex(fileId,segIndex);
	},
	
	formateFileIdWithSegIndex:function(fileId,segIndex){
		var pre=fileId.slice(0,8);
		var seg=segIndex.toString(16);
		seg=seg.length==1?"0"+seg:seg;
		seg=seg.toUpperCase();
		return pre+seg+fileId.slice(10);
	}
};

function handleDownload(task,srcPath,saveTo){
	fs.exists(saveTo,function(v){
	    if(v) {
			console.log("skip:"+saveTo);
			task.done();
		}else{
			var dl=new Download();
			dl.on("sucess",function(){
		        console.log("save ok:"+saveTo);
		    });
			dl.on("failure",function(){
		        console.log("save failure:"+saveTo);
		    });
			dl.on("complete",function(){
				task.done();
		    });
		    dl.start(srcPath,saveTo,"binary");
		}
	});    
}

var args=process.argv.slice(2);
//http://v.youku.com/v_show/id_XNTI1NDc5MzY4.html
var videoId=args[0];
var regex=/id_(\w+)/;
var matchs=videoId.match(regex);
if(matchs){
	videoId=matchs[1];
}
console.log(videoId)

var youku=new Youku(videoId);
youku.start("mp4",function(){
	console.log("dm complete.")
});

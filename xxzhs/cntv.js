var fs=require("fs");
var exec = require('child_process').exec;
var yhnode=require("yhnode");
var XMLHttpRequest=yhnode.network.http.XMLHttpRequest;
var Download=yhnode.network.Download;
var WorkPool=require("./lib/WorkPool").WorkPool;

var CNTV=yhnode.base.BaseObject.extend({
    
    initialize:function(videoType){
        this._infoUrl="http://vdn.apps.cntv.cn/api/getHttpVideoInfo.do";
        this._localSaveRoot="./video/";
        this._fileExt=".mp4";
        this._chapters=[];

        this._videoType=videoType;
        this._pathMP4Box="MP4Box";
    },
    
    start:function(videoId,cb){
        var self=this;
        this.getInfo(videoId,function(data){
            var titles=data.title.split(" ");
			var filePaht=titles.length==2?titles[1]:titles.slice(1).join("");
            self._savePath=self._localSaveRoot+titles[1];
            self.download(function(err){
				if(err) console.log("error:"+videoId);
               
//                self.joinChapter(function(){
//                    if(!error){
//                        //remove chapter
//                        fs.rmdirSync(self._savePath);  
//                    }
//                });

                cb && cb(err);
            });
        });
    },
    
    getInfo:function(videoId,cb){
        var self=this;
        var xhr=new XMLHttpRequest();
        
        xhr.onreadystatechange = function() {

            if (this.readyState == 4) {
                self._data=JSON.parse(this.responseText);
                cb&&cb(self._data);
            }
        };
		var url=this._infoUrl+"?pid="+videoId;
		console.log("url:"+url);
        xhr.open("GET",url);
        xhr.send();
    },
    
    download:function(cb){
        var videoInfo=this._data.video;
		if(!videoInfo) {
			cb(true);
			return;
		}
        var chapters;
        switch(this._videoType){
            case 1:
                chapters=videoInfo.lowChapters;
                break;
            case 2:
                chapters=videoInfo.chapters;
                break;
            case 3:
            default:
                chapters=videoInfo.chapters2;
                break;
        }
        this.downloadFiles(chapters,cb);
    },
    
    downloadFiles:function(files,cb){
        var wp=new WorkPool(3);
        var file;
        for(var i in files){
            file=files[i];
            var srcPath=file.url;
            var saveTo=this._savePath+"/"+i+this._fileExt;
            wp.add(handleDownload,null,srcPath,saveTo);
            this._chapters.push(saveTo);
        }
        cb && wp.join(cb);
    },
    
    //不能简单的将文件连接在一起
    //MP4Box 20110627/0.mp4 -cat 20110627/1.mp4 -cat 20110627/2.mp4 -cat 20110627/3.mp4 -cat 20110627/4.mp4 -cat 20110627/5.mp4 -cat 20110627/6.mp4 -cat 20110627/7.mp4 -cat 20110627/8.mp4 -out 20110627.mp4
    //mp4连接有些文件会有问题，没有声音。
    joinChapter:function(cb){
        var cmd=this._pathMP4Box+" "
        //input
        cmd+=this._chapters[0];
        //cat
        for(var i=1;i<this._chapters.length;i++){
            cmd+=" -cat "+this._chapters[i];
        }
        //output
        cmd+=" -out "+this._savePath+this._fileExt;
        //exec concat cmd
        exec(cmd,function (error, stdout, stderr) {
            cb&& cb(error);
        });
//        var saveTo=this._savePath+this._fileExt
//        var saveStream=fs.createWriteStream(saveTo,{ flags: 'w'});
//        var i=0;
//        var chapters=this._chapters;
//        var join=function(){
//            console.log("join :",chapters[i]);
//            var chapterStream=fs.createReadStream(chapters[i],{autoClose: true});
//            chapterStream.pipe(saveStream, { end: false });
//            chapterStream.on("end", function() {
//                if(++i<chapters.length){
//                     join();   
//                }else{
//                    saveStream.close();
//                }
//            });
//        };
//        join();
    }
},{
    VideoType:{
        Normal:1,
        High:2,
        Ultra:3
    }
});

module.exports=CNTV;

function handleDownload(task,srcPath,saveTo){
	fs.exists(saveTo,function(v){
	    if(v) {
			console.log("skip:"+saveTo);
			task.done();
		}else{
			var dl=new Download();
            var retryTimes=3;
			dl.on("sucess",function(){
		        console.log("save ok:"+saveTo);
		    });
			dl.on("failure",function(){
		        console.log("save failure:"+saveTo);
		    });
			dl.on("complete",function(){
				task.done();
		    });
            dl.on("error",function(ex){
                console.error(ex);
                if(retryTimes-->0){
				    dl.start(srcPath,saveTo,"binary");
                }
		    });
		    dl.start(srcPath,saveTo,"binary");
		}
	});    
}



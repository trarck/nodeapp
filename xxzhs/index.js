var fs=require("fs");
var yhnode=require("yhnode");
var XMLHttpRequest=yhnode.network.http.XMLHttpRequest;
var CNTV=require("./CNTV");
var ColumnList=require("./ColumnList").ColumnList;

var allListUrl="http://tv.cntv.cn/index.php?action=video-getVideoList&infoId=C16717000001&type=CN04&flag=cu&videoId=0c680e2d319f41b2b25eb73c33a0915d&istiyu=0";//&page=1;

// var cntv=new CNTV(CNTV.VideoType.Ultra);
// cntv.start("f5cca9284e974d546e209ea6ca690113",function(){
// 
// });

var colList=new ColumnList(allListUrl);

colList.load(function(list){
	var app;
	var currentIndex=0;
	
	var handleDownload=function(){
		if(currentIndex<list.length){
			app=list[currentIndex];
	        if(!app.loaded){
			    var cntv=new CNTV(CNTV.VideoType.Ultra);
			    cntv.start(app.id,function(){
			        colList.updateListItem(currentIndex,{loaded:true});
					++currentIndex;
		        	handleDownload();
			    });
	        }else{
				++currentIndex;
	        	handleDownload();
	        }
		}
	};
	handleDownload();
});


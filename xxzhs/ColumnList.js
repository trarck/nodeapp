var fs=require("fs");
var yhnode=require("yhnode");
var XMLHttpRequest=yhnode.network.http.XMLHttpRequest;
var WorkPool=require("./lib/WorkPool").WorkPool;

var XML2Object=require("../lib/XML2Object");

var ColumnList=exports.ColumnList=yhnode.base.BaseObject.extend({
    
    initialize:function(url,listFile){
        this._url=url;
        this._currentPage=1;
        this._maxPage=0;
        this._shouldGetMaxPage=true;
        this._list=[];
        this._localListFile=listFile||"list.json";
		this._listIdMap={};
    },
    
    load:function(cb){
        
        var self=this;
        fs.exists(this._localListFile,function(v){
            if(v){
                var cnt=fs.readFileSync(self._localListFile).toString();
				self._list=JSON.parse(cnt);
                cb && cb(self._list);
            }else{
                self.getAllList(function(){
                   self.saveList();
                   cb && cb(self._list);
                });
            }
        });
    },
	
	create:function(cb){
		var self=this;
        this.getAllList(function(){
           self.saveList();
           cb && cb(self._list);
        });
	},
	
	update:function(cb){
		//取得直到在更新列表中
		var self=this;

		this.load(function(){
			self._listIdMap=self.createListIdMap();
			
		});
	},
	
	createListIdMap:function(){
		var map={};
		var it;
		for(var i in this._list){
			it=this._list[i];
			map[it.id]=it;
		}
		return map;
	},

    saveList:function(){
        fs.writeFileSync(this._localListFile,JSON.stringify(this._list,null,4));
    },

    updateListItem:function(index,attr){
        var it=this._list[index];
        if(it){
            yhnode.base.Core.mixin(it,attr);
        }
        this.saveList();
    },

    getAllList:function(cb){
        this.singleGetList(cb);
    },
    
    singleGetList:function(cb){
        var self=this;
        var down=function(){
            self.getPageItmes(self._currentPage,function(){
                if(++self._currentPage<=self._maxPage){
                    self.getPageItmes(self._currentPage,down);
                }else{
                    cb && cb();
                }
            });
        };
        down();
    },
    
    multiGetList:function(cb){
        var self=this;
        var down=function(){
            var wp=new WorkPool(3);
            for(;self._currentPage<=self._maxPage;self._currentPage++){
                wp.add(handleDownload,null,self,self._currentPage);
            }
            cb && wp.join(cb);
        };

        if(this._shouldGetMaxPage && !this._maxPage){
            this.getPageItmes(this._currentPage,function(){
                ++self._currentPage;
                down();
            });
        }else{
            down();
        }
    },
    
    getPageItmes:function(page,cb){
        console.log("getPageItmes:",page);
        var self=this;
        this.getInfo(page,function(responseText){
            var items=self.parseInfoData(responseText);
            self._list=self._list.concat(items);
            cb && cb();
        });
    },
    
    getInfo:function(page,cb){
        var url=this._url+"&page="+page;
        console.log("url:",url);
        var xhr=new XMLHttpRequest();
		xhr.onreadystatechange = function() {
		    if (this.readyState == 4) {
		        cb(this.responseText);
		    }
		};

		xhr.open("GET", url);
		xhr.send();
    },
    
    parseInfoData:function (content) {
        //add root
        content="<root>"+content+"</root>";
        var x2o=new XML2Object(true);
        x2o.parse(content);
        var root=x2o.getData().root;
        
        var items=[];
        var dl=root[0].div[0].dl;
        for(var i=0;i<dl.length;i++){
			//最后一个元素分隔符
            for(var j=0;j<dl[i].dd.length-1;j++){
                items.push(this.createAppInfo(dl[i].dd[j]));
            }
        }

        if(!this._maxPage && this._shouldGetMaxPage){
            this._maxPage=parseInt(root[1].div[root[1].div.length-2].text);
            this._shouldGetMaxPage=false;
			console.log("maxPage:"+this._maxPage);
        }
		
        return items;
    },
    
    createAppInfo:function(info){
        var hrefs=info.href.split("/");
        var appId=hrefs[hrefs.length-1];
		if(appId.length<30) console.log(info);
        return {
            id:appId,
            title:info.title
        };
    }
});

function handleDownload (task,owner,page) {
    owner.getPageItmes(page,function(){
        task.done();
    });
}
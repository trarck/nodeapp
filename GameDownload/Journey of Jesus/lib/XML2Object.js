var emitter = require('events').EventEmitter;
var fs = require('fs');
var sax = require('sax');
var Stream = require('stream');
var util = require('util');
var yhnode=require('yhnode');

/**
 *
 * attribute做为对象的值
 * 有且只有一个root
 * 子元素使用数组。子元素的标签一至 
 */

var XML2Object = module.exports = yhnode.base.BaseObject.extend({
    
    initialize:function(strict,useRootTagName){
        this._strict=strict;

        this._useRootTagName=typeof (useRootTagName)=="undefined"?true:useRootTagName;

        this._root=null;
        this._deep=0;
        this._tagStack=[];
    },

    getData:function(){
        return this._root;
    },

    parse:function(source){
        this._deep=0;
        this._tagStack=[];
        this._root={};

        this.createParser(source);
    },

    createParser:function(source){
        this.createContentParser(source);
    },
    createStreamParser:function(){
    
    },
    createContentParser:function(content){
        var parser=this._parser=sax.parser(this._strict);

        var self=this;
        parser.onerror = function (e) {
          self.doParseError(e);
        };
       
        parser.onopentag = function (node) {
          self.doParseOpenTag(node);
        };

        parser.onclosetag = function (tagName){
            self.doParseCloseTag(tagName);
        };

        parser.ontext = function (text) {
          self.doParseText(text);
        };
//        parser.onattribute = function (attr) {
//          self.doParseAttribute(attr);
//        };
        parser.onend = function () {
          self.doParseEnd();
        };
        parser.write(content).close();
    },
    doParseError:function(err){
    
    },
    doParseOpenTag:function(node){

//        console.log("tag:",node,this._deep);

        
        this._tagStack.push(node);

        if(this._deep>1){
            var parentTag=this._tagStack[this._tagStack.length-2];

            if(!parentTag._obj_[parentTag.name]) parentTag._obj_[parentTag.name]=[];  
            parentTag._obj_[parentTag.name].push(node.attributes);
        
            node._obj_=node.attributes;
        }else if(this._deep>0 && this._useRootTagName){
            var parentTag=this._tagStack[this._tagStack.length-2];
            if(!parentTag._obj_[parentTag.name]) parentTag._obj_[parentTag.name]=[];  
            parentTag._obj_[parentTag.name].push(node.attributes);
            node._obj_=node.attributes;
        }else{
            yhnode.base.Core.mixin(this._root,node.attributes);
            node._obj_=this._root;
        }

        this._deep++;
        
    },
    doParseCloseTag:function(tagName){
//        console.log("close:",tagName);
        this._deep--;
        this._tagStack.pop();
    },
    doParseText:function(text){
//        console.log("text:",text);
    },
    doParseAttribute:function(attr){
//        console.log("attr:",attr);
    },
    doParseEnd:function(){
    
    }

},null,emitter);

////var xmlstr='<root><files><file name="a"><time v="1"/><time v="2"/></file><file name="b"/></files><dir><file name="a"/><file name="b"/></dir></root>';
//var xmlstr='<files><file name="a" /><file name="b"/></files>';
//var x2o=new XML2Object(true);
//x2o.parse(xmlstr);
//console.log(JSON.stringify(x2o.getData(),null,4));
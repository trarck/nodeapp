var emitter = require('events').EventEmitter;
var fs = require('fs');
var sax = require('sax');
var Stream = require('stream');
var util = require('util');
var yhnode=require('yhnode');

var XMLDOM = module.exports = yhnode.base.BaseObject.extend({
    
    initialize:function(strict){
        this._strict=strict;

        this._onlyOneRoot=true;

        this._currentTag=null;
        this._deep=0;
        this._outObject={children:[]};
    },

    getData:function(){
        if(this._onlyOneRoot){
            return this._outObject.children[0];
        }
        return this._outObject.children;
    },

    parse:function(source){
        this._currentTag=null;
        this._deep=0;
        this._outObject={children:[]};
        this._currentTag=this._outObject;

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
        parser.onattribute = function (attr) {
          self.doParseAttribute(attr);
        };
        parser.onend = function () {
          self.doParseEnd();
        };
        parser.oncdata=function(){
            self.doParseCdata();
        };
        parser.write(content).close();
    },
    doParseError:function(err){
    
    },
    doParseOpenTag:function(node){
        console.log("tag:",node);

        if(!this._currentTag.children) this._currentTag.children=[];

        this._currentTag.children.push(node);

        if(this._deep>0)
            node.parent=this._currentTag;

        this._deep++;
        this._currentTag=node;
        
    },
    doParseCloseTag:function(tagName){
        console.log("close:",tagName);
        this._deep--;
        this._currentTag=this._currentTag.parent;
    },
    doParseText:function(text){
        console.log("text:",text);
        this._currentTag.text=text;
    },
    doParseCdata:function(cdata){
        console.log("cdata:",cdata);
        this._currentTag.cdata=cdata;
    },
    doParseAttribute:function(attr){
        console.log("attr:",attr);
    },
    doParseEnd:function(){
    
    }

},null,emitter);
//
//var xmlstr='<root><files><file name="a"/><file name="b"/></files></root>';
//var xmlDoc=new XMLDOM(true);
//xmlDoc.parse(xmlstr);
//console.log(xmlDoc.getData());
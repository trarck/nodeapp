
var MatrixInterpolation=require("./MatrixInterpolation");
var RelationMap=require("./RelationMap");

var ConvertFca=function(fca,convertMotion){
    this.fca=fca;
    this.convertMotion=convertMotion;

    this._relationMap=new RelationMap();

    this._baseLayerElementId=0;

    this._testNextItemDeep=10;
};

ConvertFca.prototype={

    setConvertMotion:function(convertMotion){
        this.convertMotion=convertMotion;
        return this;
    },

    getConvertMotion:function(){
        return this.convertMotion;
    },


    convertActions:function (){
        var ret=[];
        var actions=this.fca.actions;
        for(var i in actions){
            var action=actions[i];
            ret.push(this.convertAction(action));
        }
        return ret;
    },

    convertAction:function (action){

        return {
            name:action.name,
            frameCount:action.frames.length,
            layers:this.convertActionElements(action),
            eventLayers:this.convertActionEvents(action)
        };
    },

    convertActionElements:function (action){
        var characters=this.fca.elements;
        var frames=action.frames;
        var baseLayers=this.makeBaseLayers(action);
        var layers=[];

        //处理element
        for(var i=0;i<baseLayers.length;++i){
            var elementIndex=baseLayers[i];
            var character=characters[elementIndex-1];
            var layer={
                element:character.name,
                frames:[]
            };

            var layerFrame;
            //分离出关键帧
            for(var k=0;k<frames.length;++k){
                var frame=frames[k];
                var ele=this.getElement(frame.elements,baseLayers[i]);
                if(ele){
                    //check the property.now is alpha and matrix;
                    if(layerFrame && this.isFramePropertySame(layerFrame,ele)){
                        ++layerFrame.continueCount;
                    }else{
                        layerFrame={
                            startFrame:k,
                            continueCount:1,
                            alpha:ele.alpha,
                            matrix:ele.matrix
                        };
                        layer.frames.push(layerFrame);
                    }
                }else{
                    //the frame is not visible
                    if(layerFrame){
                        layerFrame=null;
                    }
                }
            }

            //加个开关，是否使用补间
            if(this.convertMotion){
                this.convertKeyFrameToMotion(layer);
            }

            layers.push(layer);
        }

        return layers;
    },

    convertKeyFrameToMotion:function(layer){
        //关键帧转成补间
        //如果一段连续的关键帧有相同的插值，则可以转换成补间
        var startFrame=-1;
        var prevFrame,nextFrame,layerFrame;
        for(var k=0;k<layer.frames.length-1;++k){
            layerFrame=layer.frames[k];
            //如果持续帧大于1，则后面不是关键帧，则不会转成补间。补间在被导出的时候，转成的帧前后值不一样。
            if(layerFrame.continueCount==1){

                if(startFrame==-1){
                    startFrame=k;
                    //跳过此帧
                }else{
                    //补间已经开始
                    prevFrame=layer.frames[k-1];
                    nextFrame=layer.frames[k+1];
                    if(!MatrixInterpolation.haveSameInterpolation(prevFrame.matrix,layerFrame.matrix,nextFrame.matrix)){
                        //补间结束
                        if(k-startFrame>1){
                            //2个以上才创建
                            layer.frames[startFrame].tweenType="motion";
                            layer.frames[startFrame].duration=k-startFrame;
                        }
                        startFrame=k;
                    }
                }
                //检查插值
            }else{
                //补间结束
                if(startFrame!=-1){
                    //已经有补间
                    if(k-startFrame>1) {
                        //2个以上才创建
                        layer.frames[startFrame].tweenType = "motion";
                        layer.frames[startFrame].duration = k - startFrame;
                    }

                    startFrame=-1;
                }
            }
        }

        //结束处理
        if(startFrame!=-1){
            var lastFrame=layer.frames.length-1;
            if(lastFrame-startFrame>1) {
                //2个以上才创建
                layer.frames[startFrame].tweenType = "motion";
                layer.frames[startFrame].duration = lastFrame - startFrame;
            }
        }

        //删除被补间转换成的关键帧
        for(var k=0;k<layer.frames.length;++k) {
            layerFrame = layer.frames[k];
            if(layerFrame.tweenType){
                //fl.trace("delete from "+(k+1)+" to "+ (k+layerFrame.duration-1));
                layer.frames.splice(k+1,layerFrame.duration-1);
            }
        }

        return layer;
    },

    convertActionEvents:function(action){
        //处理event.按类型分层。同一帧不能有重复的类型。
        var eventLayers=[];

        var eventType;
        var eventLayer;
        var layerFrame;

        var frames=action.frames;
        for(var k=0;k<frames.length;++k){
            var frame=frames[k];
            if(frame.events && frame.events.length){
                for(var j=0;j<frame.events.length;++j){
                    eventType=frame.events[j].type;

                    eventLayer=eventLayers[eventType];
                    //没有则创建
                    if(!eventLayer){
                        eventLayer={
                            name:EventLayerPrefix+EventTypeNames[eventType],
                            frames:[]
                        };

                        eventLayers[eventType]=eventLayer;
                    }

                    switch (eventType){
                        case EventType.Sound:
                            layerFrame={
                                startFrame:k,
                                type:eventType,
                                soundName:frame.events[j].arg
                            };
                            eventLayer.frames.push(layerFrame);
                            break;
                        case EventType.AddEffect:
                            break;
                        case EventType.RemoveEffect:
                            break;
                    }
                }
            }
        }

        //remove the None layer
        if(!eventLayers[EventType.None] || eventLayers[EventType.None].frames.length==0){
            eventLayers.shift();
        }
        return eventLayers;
    },

    isFramePropertySame:function (aFrame,bFrame){
        return aFrame.alpha==bFrame.alpha
            && aFrame.matrix.a==bFrame.matrix.a
            && aFrame.matrix.b==bFrame.matrix.b
            && aFrame.matrix.c==bFrame.matrix.c
            && aFrame.matrix.d==bFrame.matrix.d
            && aFrame.matrix.tx==bFrame.matrix.tx
            && aFrame.matrix.ty==bFrame.matrix.ty;
    },

    getElement:function (elements,index){
        for(var i in elements){
            if(elements[i].index==index){
                return elements[i];
            }
        }

        return null;
    },

    /**
     * 按照每帧元素的关系确定原来的层的关系。
     * 使用前导检查，就确定当前元素在哪个元素后面，可能是紧挨着，也可能隔几个。
     * 因为第一个元素没有前面元素，可以使用在后面元素之前来定位。
     * 一个元素可能会在不同的层出现，但不会重叠。
     */
    makeBaseLayers:function (action){
        //make the id is not same as index
        this._baseLayerElementId=this.fca.elements.length;

        this._elementIndexLayerIdMap={};

        var frames=action.frames;

        var layers=[];

        var ele,nextEle,prevEle;
        var elePos,nextElePos,prevElePos;

		var extLayers=[];
		var checkedElements={};
        var extElementsSign={};

        var self=this;

        function parseExistsElement(frame,frameIndex,elePos){
            var extLayerObj;
            var ele=frame.elements[elePos];
            var nextEle,prevEle;

            var checkRet=self.checkNextItemsIsAfter(frame.elements,ele.index,elePos+1,checkedElements,self._testNextItemDeep);
            if(!checkRet.result){
                //关系不对,前面的元素出现在了后面(遮挡需要)。
                console.log("after relation ship correct frame="+frameIndex+",i="+elePos+",ele="+ele.index);

                //继续检查后面的元素是否都在当前元素之前，是否有多个图层做了移动。
                var checkBeforeRet=self.checkNextItemsIsBefore(frame.elements,ele.index,checkRet.stop+1,checkedElements,self._testNextItemDeep);

                //处理移动量最少的。
                //后续的元素和当前元素下面的元素比较
                if(checkBeforeRet.count<checkRet.count+1){
                    //小于，表示前面的元素后移，即下面的图层上移。
                    //当前元素没问题，检测停止的元素为被调整的元素

                    ele=frame.elements[checkRet.stop];

                    //标记已经处理过，接着检查可以忽略
                    checkedElements[ele.index]=true;

                    elePos=checkRet.stop;

                    //prevEle=frame.elements[checkRet.stop-1];
                    //nextEle=frame.elements[checkRet.stop+1];
                    //
                    //extLayerObj=self.getExtLayerObject(extLayers,ele.index,prevEle.index,nextEle.index);
                    //if(!extLayerObj){
                    //    extLayerObj=self.createExtLayerObject(ele.index,prevEle.index,nextEle.index);
                    //    extLayers.push(extLayerObj);
                    //}
                    //
                    //extLayerObj.frames.push(frameIndex);
                    //
                    //extElementsSign[checkRet.stop]=extLayerObj;
                }else{
                    //大于或等于，后面的元素前移，即上面的图层下移。
                    //当前元素为被调整的元素

                    //由于当前元素已经被检测过，不用在设置跳过检查标记。
                    //prevEle=frame.elements[elePos-1];
                    //nextEle=frame.elements[elePos+1];
                    //
                    ////取得一个扩展的层
                    //extLayerObj=self.getExtLayerObject(extLayers,ele.index,prevEle.index,nextEle.index);
                    //if(!extLayerObj){
                    //    extLayerObj=self.createExtLayerObject(ele.index,prevEle.index,nextEle.index);
                    //    extLayers.push(extLayerObj);
                    //}else{
                    //    //检查和前面一个元素的关系
                    //    if(!extElementsSign[elePos-1] && this._relationMap.compareRelation(prevEle.index,extLayerObj.id)==0) {
                    //        //关系不确认，建立关系
                    //        self._relationMap.setRelation(prevEle.index, extLayerObj.id, -1);
                    //        self.fixLayerObject(extLayerObj,prevEle.index);
                    //    }
                    //}
                    //
                    ////做个帧标记
                    //extLayerObj.frames.push(frameIndex);
                    //
                    //extElementsSign[elePos]=extLayerObj;

                    ////不考虑整体移动的情况，会在下个循环的元素处理。有可能下个元素是新加的
                }

                prevEle=frame.elements[elePos-1];
                nextEle=frame.elements[elePos+1];

                //取得一个扩展的层
                extLayerObj=self.getExtLayerObject(extLayers,ele.index,prevEle.index,nextEle.index);
                if(!extLayerObj){
                    extLayerObj=self.createExtLayerObject(ele.index,prevEle.index,nextEle.index);
                    extLayers.push(extLayerObj);
                }else{
                    //检查和前面一个元素的关系
                    if(!extElementsSign[elePos-1] && self._relationMap.compareRelation(prevEle.index,extLayerObj.id)==0) {
                        //关系不确认，建立关系
                        self._relationMap.setRelation(prevEle.index, extLayerObj.id, -1);
                        self.fixLayerObject(extLayerObj,prevEle.index);
                    }
                }

                //做个帧标记
                extLayerObj.frames.push(frameIndex);

                extElementsSign[elePos]=extLayerObj;
            }

            return checkRet.result;
        }

        for(var k=0;k<frames.length;++k){
            var frame=frames[k];
            if(frame.elements.length==0)
                continue;

            extElementsSign={};

            //first element
            ele=frame.elements[0];

            if(frame.elements.length==1){
                //只有一个元素
                if(layers.indexOf(ele.index)!=-1){
                    //存在，则不比较
                    continue;
                }else{
                    //添加到后面，待后面帧处理
                    layers.push(ele.index);
                }
            }else{
				checkedElements={};

                //多个元素
                //处理第一个元素
                ele=frame.elements[0];
                //第一帧的第一个元素直接加入
                if(k==0){
                    layers.push(ele.index);
                }else{
                    elePos=layers.indexOf(ele.index);
                    //第一个元素没有加入，则加在下个存在元素的前面。已经加入不做处理
                    if(elePos==-1){
                        //加入下个元素的前面
                        var insertPos=-1;
                        var j=1;
                        do{
                            nextEle=frame.elements[j];
                            if(!nextEle){
                                console.log(k,i,j);
                            }
                            insertPos=layers.indexOf(nextEle.index);
                        }while(insertPos==-1 && ++j<frame.elements.length);

                        layers.splice(insertPos,0,ele.index);
                    }else{
                        //检查和后面元素的关系
                        parseExistsElement(frame,k,0);
                    }
                }

                //最后面一个元素不检查
                for(var i=1;i<frame.elements.length-1;++i){
                    ele=frame.elements[i];

                    elePos=layers.indexOf(ele.index);
                    prevEle=frame.elements[i-1];
                    if(elePos==-1){
                        //元素还未加入，加在前面元素的后面。
                        //前一个元素一定在layers中。
                        insertPos=layers.indexOf(prevEle.index)+1;
                        layers.splice(insertPos,0,ele.index);

                        this._relationMap.setRelation(prevEle.index,ele.index,-1);
                    }else{
                        //检查后续元素的关系
                        var checkResult=parseExistsElement(frame,k,i);
                        if(checkResult){
                            //不是扩展层

                            //检查和前面一个元素的关系
                            if(this._relationMap.compareRelation(prevEle.index,ele.index)==0) {
                                //关系不确认，建立关系
                                this._relationMap.setRelation(prevEle.index, ele.index, -1);
                                //重新排序
                                console.log("sort layers frame="+k+",i="+i+",ele="+ele.index+",prev="+prevEle.index);
                                this.sortLayers(layers);
                            }
                        }
                    }
                }
            }
        }

        console.log(extLayers);

        //merge extLayers to layers
        for(var i=0;i<extLayers.length;++i){
            var extLayerObj=extLayers[i];
            var prevPos=layers.indexOf(extLayerObj.prev);
            layers.splice(prevPos+1,0,extLayerObj.index);
        }

        return layers;
    },

	checkNextItemsIsAfter:function(elements,currentElementIndex,from,skipElements,maxStep){
		var step=0;
		var count=0;//检测到符合条件的元素数
		var ret={};

        //var isFirst=true;
        //var firstResult=0;
        var retResult=true;
        var result;

		for(;from<elements.length;++from){
			var ele=elements[from];
			if(skipElements && skipElements[ele.index]){
				continue;
			}

			result=this._relationMap.compareRelation(currentElementIndex,ele.index);
            //if(isFirst){
            //    firstResult=result;
            //    isFirst=false;
            //}
			//ele在检测元素之前，检测结束。
			if(result>0){
				//ret.result=false;
				//ret.count=count;
				//ret.stop=from;
                //ret.firstResult=firstResult;
				//return ret;
                retResult=false;
                break;
			}else if(result<0){
				step++;
			}

			//如果不确定，则继续,不消耗深度，但会增加数量
			count++;
			if( maxStep && step<maxStep){
				break;
			}
		}
	
		ret.result=retResult;
		ret.count=count;
		ret.stop=from;
        //ret.firstResult=firstResult;
		return ret;
    },

	checkNextItemsIsBefore:function(elements,currentElementIndex,from,skipElements,maxStep){
		var step=0;
		var count=0;//检测到符合条件的元素数
		var ret={};

		for(;from<elements.length;++from){
			var ele=elements[from];
			if(skipElements && skipElements[ele.index]){
				continue;
			}

			var result=this._relationMap.compareRelation(currentElementIndex,ele.index);
			//ele在检测元素之后，停止检测。
			if(result<0){
				ret.result=false;
				ret.count=count;
				ret.stop=from;
				return ret;
			}else if(result>0){
				step++;
			}

			//如果不确定，则继续,不消耗深度，但会增加数量
			count++;
			if( maxStep && step<maxStep){
				break;
			}
		}
	
		ret.result=true;
		ret.count=count;
		ret.stop=from;
		return ret;
    },

    createBaseLayerObject:function(index,prev,next){
        var layerObj={
            id:++this._baseLayerElementId,
            index:index,
            prev:prev,
            next:next,
            frames:[]
        };

        return layerObj;
    },

    createExtLayerObject:function(index,prev,next){
        var layerObj={
            id:++this._baseLayerElementId,
            index:index,
            prev:prev,
            next:next,
            frames:[]
        };

        return layerObj;
    },

    getExtLayerObject:function(layers,index,prev,next){
        var layerObj;
        for(var i=0;i<layers.length;++i){
            layerObj=layers[i];

            if(layerObj.index==index){
                //check prev and next
                if( (this._relationMap.compareRelation(layerObj.prev,prev)!=1 && this._relationMap.compareRelation(layerObj.next,next)!=-1) ||
                    (this._relationMap.compareRelation(layerObj.prev,prev)!=-1 && this._relationMap.compareRelation(layerObj.next,next)!=1)){
                    return layerObj;
                }
            }
        }
        return null;
    },

    /**
     * 修正layerObj范围
     * @param layerObj
     * @param prev
     * @param next
     * @returns {*}
     */
    fixLayerObject:function(layerObj,prev,next){
        if(prev && this._relationMap.compareRelation(layerObj.prev,prev)==-1){
            layerObj.prev=prev;
        }
        if(next && this._relationMap.compareRelation(layerObj.next,next)==1){
            //need fix
            layerObj.next=next;
        }
        return layerObj;
    },

    getLayerObject:function(layers,index,prev,next){
        var layerObj;
        var tempObj;
        var passPrev,passNext;
        for(var i=0;i<layers.length;++i){
            layerObj=layers[i];

            if(layerObj.index==index){
                //check prev and next
                if(prev){
                    passPrev=false;
                    for(var j=i-1;j>=0;--j){
                        if(layers[j].index==prev){
                            passPrev=true;
                        }
                    }
                }else{
                    passPrev=true;
                }

                if(next){
                    passNext=false;
                    for(var j=i+1;j<layers.length;++j){
                        tempObj=layers[j];

                        //检查next之前是否有相同元素
                        if(tempObj.index==index){
                            //stop on next same
                            break;
                        }

                        if(tempObj.index==next){
                            passNext=true;
                        }
                    }
                }else{
                    passNext=true;
                }

                if(passPrev && passNext){
                    return layerObj
                }
            }
        }
        return null;
    },

    getBaseLayerObject:function(index){
        var list=this._elementIndexLayerIdMap[index];
        return list && list.length==1?list[0]:list;
    },

    getBaseLayerObjectEx:function(index,prev,next){
        var list=this._elementIndexLayerIdMap[index];
        if(!list)
            return null;

        if(list.length==1){
            return list[0];
        }else{

        }
    },

    sortLayers:function(layers){
        var self=this;
        layers.sort(function(a,b){
            var r=self._relationMap.compareRelation(a,b)
            return  r==0?1:r;
        });

        return layers;
    },



    getPositionBeforeElement:function (element,layers){
        if(layers.length==0) return 0;

        return layers.indexOf(element);
    },

    getPositionAfterElement:function (element,layers){
        if(layers.length==0) return 0;

        var pos=layers.indexOf(element);
    
        return pos==-1?-1:pos+1;
    },

    comparePosition:function (currentPosition,element,layers){
        if(layers.length==0) return 0;

        var pos=layers.indexOf(element);
        if(pos==-1){
            //unknown
            return 0;
        }else if(currentPosition<pos){
            //before
            return -1;
        }else if(currentPosition>pos){
            //after
            return 1;
        }else{
            //error
            throw "the current position is same as element index";
        }   
        
        return -999;
    },

    isPositionBeforeElement:function (currentPosition,element,layers){
        if(layers.length==0) return 0;

        var pos=layers.indexOf(element);
        
        return pos==-1?true:(currentPosition<pos);
    },

    isPositionAfterElement:function (currentPosition,element,layers){
        if(layers.length==0) return 0;

        var pos=layers.indexOf(element);
        
        return pos==-1?true:(currentPosition>pos);
    },
    
    isPositionBetweenElement:function (currentPosition,beforeElement,afterElement,layers){
        if(layers.length==0) return 0;

        var beforePos=layers.indexOf(beforeElement);
        var afterPos=layers.indexOf(afterElement);
        
        return currentPosition>beforePos && currentPosition<afterPos;
    }
};
module.exports=ConvertFca;
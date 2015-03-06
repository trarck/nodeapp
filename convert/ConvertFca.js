
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
        this._baseLayerElementId=0;
        this._elementIndexLayerIdMap={};

        var frames=action.frames;

        var layers=[];

        var ele,nextEle,prevEle;
        var elePos,nextElePos,prevElePos;

		var extLayers=[];
		var checkedElements={};

        for(var k=0;k<frames.length;++k){
            var frame=frames[k];
            if(frame.elements.length==0)
                continue;

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
                        if(!this.nextItemsIsAfter(frame.elements,ele.index,1)){
                            console.log("some relation ship correct frame="+k+",i=0");
                        }
                    }
                }


                for(var i=1;i<frame.elements.length;++i){
                    ele=frame.elements[i];

                    elePos=layers.indexOf(ele.index);
                    if(elePos==-1){
                        //元素还未加入，加在前面元素的后面。
                        //前一个元素一定在layers中。
                        prevEle=frame.elements[i-1];
                        insertPos=layers.indexOf(prevEle.index)+1;
                        layers.splice(insertPos,0,ele.index);

                        this._relationMap.setRelation(prevEle.index,ele.index,-1);
                    }else{
                        //检查后续元素的关系
						var checkRet=this.checkNextItemsIsAfter(frame.elements,ele.index,i,checkedElements,this._testNextItemDeep);
                        if(!checkRet.result){
                            //关系不对,前面的元素出现在了后面(遮挡需要)。
                            console.log("after relation ship correct frame="+k+",i="+i+",ele="+ele.index);

							//继续检查后面的元素是否都在当前元素之前，是否有多个图层做了移动。
							var checkBeforeRet=this.checkNextItemsIsBefore(frame.elements,ele.index,checkRet.stop+1,checkedElements,this._testNextItemDeep);
							
							//处理移量最少的。
							//后续的元素和当前元素下面的元素比较
							if(checkBeforeRet.count<checkRet.count){
								//小于，表示前面的元素后移，即下面的图层上移。

							}else{
								//大于或等于，后面的元素前移，即上面的图层下移。
							}
                        }

                        ////检查和上个元素的关系
                        //prevEle=frame.elements[i-1];
                        //var result=this._relationMap.compareRelation(prevEle.index,ele.index);
                        //if(!result){
                        //    //没有建立关系
                        //    this._relationMap.setRelation(prevEle.index,ele.index,-1);
                        //    //检查是否需要排序
                        //    prevElePos=layers.indexOf(prevEle.index);
                        //    if(prevElePos>elePos){
                        //        //sort layers
                        //        this.sortLayers(layers);
                        //    }
                        //}else if(result>0){
                        //    //关系不对
                        //    console.log("before relation ship correct frame="+k+",i="+i+",ele="+ele.index+",prev="+prevEle.index+",result="+result);
                        //}else if(!this.nextItemsIsAfter(frame.elements,ele.index,i)){
                        //    //关系不对
                        //    console.log("after relation ship correct frame="+k+",i="+i+",ele="+ele.index);
                        //}
                    }
                }
            }
        }

        return layers;
    },

	checkNextItemsIsAfter:function(elements,currentElementIndex,from,skipElements,maxStep){
		var step=0;
		var count=0;//检测到符合条件的元素数
		var ret={};

		for(;from<elements.length;++from){
			var ele=elements[from];
			if(skipElements && skipElements[ele.index]){
				continue;
			}

			var result=this._relationMap.compareRelation(currentElementIndex,ele.index);
			//ele在检测元素之前，检测结束。
			if(result>0){
				ret.result=false;
				ret.count=count;
				ret.stop=from;
				return ret;
			}else if(result<0){
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
            next:next
        };

        var list=this._elementIndexLayerIdMap[index];
        if(!list){
            list=this._elementIndexLayerIdMap[index]=[];
        }
        list.push(layerObj);
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
            return self._relationMap.compareRelation(a,b);
        });
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
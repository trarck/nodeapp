package com.cntv.common.model.parser
{
    import com.cntv.common.model.*;
    import com.cntv.player.playerCom.relativeList.model.vo.*;

    public class RelativeListParser extends Object
    {

        public function RelativeListParser()
        {
            return;
        }// end function

        public static function parse(param1:XML, param2:Boolean = false) : void
        {
            var _loc_3:XMLList = null;
            var _loc_4:int = 0;
            var _loc_5:Object = null;
            var _loc_6:int = 0;
            var _loc_7:RelativeVO = null;
            var _loc_8:Boolean = false;
            var _loc_9:Number = NaN;
            if (param2)
            {
                ModelLocator.getInstance().relativeListTitle = [];
                _loc_3 = XMLList(param1.option);
                _loc_4 = 0;
                while (_loc_4 < param1.child("option").length())
                {
                    
                    _loc_5 = new Object();
                    _loc_5.title = _loc_3[_loc_4];
                    _loc_5.link = _loc_3[_loc_4].@link;
                    ModelLocator.getInstance().relativeListTitle.push(_loc_5);
                    _loc_4++;
                }
            }
            else
            {
                ModelLocator.getInstance().relativeList = [];
                _loc_6 = 0;
                while (_loc_6 < param1.children().length())
                {
                    
                    _loc_7 = new RelativeVO(param1.children()[_loc_6]);
                    _loc_8 = false;
                    _loc_9 = 0;
                    while (_loc_9 < ModelLocator.getInstance().relativeList.length)
                    {
                        
                        if (ModelLocator.getInstance().relativeList[_loc_9].url == _loc_7.url || ModelLocator.getInstance().relativeList[_loc_9].desc == _loc_7.desc)
                        {
                            _loc_8 = true;
                            break;
                        }
                        _loc_9 = _loc_9 + 1;
                    }
                    if (!_loc_8)
                    {
                        ModelLocator.getInstance().relativeList.push(_loc_7);
                    }
                    _loc_6++;
                }
            }
            return;
        }// end function

    }
}

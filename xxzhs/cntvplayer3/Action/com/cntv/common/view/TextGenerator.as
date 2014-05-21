package com.cntv.common.view
{
    import flash.text.*;

    public class TextGenerator extends Object
    {

        public function TextGenerator()
        {
            return;
        }// end function

        public static function createTxt(param1:uint, param2:int, param3:String, param4:Boolean = false, param5:Number = 0, param6:Boolean = false, param7:String = null) : TextField
        {
            var _loc_8:* = new TextField();
            var _loc_9:* = new TextFormat(param7, param2, param1, param6);
            new TextFormat(param7, param2, param1, param6).align = TextFormatAlign.LEFT;
            _loc_8.defaultTextFormat = _loc_9;
            _loc_8.textColor = param1;
            _loc_8.selectable = false;
            _loc_8.background = false;
            _loc_8.text = param3;
            _loc_8.autoSize = TextFieldAutoSize.LEFT;
            var _loc_10:* = param2;
            if (param4 && param5 > 0)
            {
                while (_loc_8.textWidth > param5 && _loc_10 >= 10)
                {
                    
                    _loc_10 = _loc_10 - 1;
                    _loc_9.size = _loc_10;
                    _loc_8.setTextFormat(_loc_9);
                }
            }
            return _loc_8;
        }// end function

        public static function createFontTxt(param1:uint, param2:int, param3:String, param4:String, param5:Boolean = false) : TextField
        {
            var _loc_6:* = new TextField();
            var _loc_7:* = new TextFormat(param4, param2);
            new TextFormat(param4, param2).align = TextFormatAlign.LEFT;
            _loc_7.bold = param5;
            _loc_6.defaultTextFormat = _loc_7;
            _loc_6.textColor = param1;
            _loc_6.selectable = false;
            _loc_6.background = false;
            _loc_6.text = param3;
            _loc_6.autoSize = TextFieldAutoSize.LEFT;
            return _loc_6;
        }// end function

        public static function createFontHtmlTxt(param1:uint, param2:int, param3:String, param4:String, param5:Boolean = false, param6:Number = 0) : TextField
        {
            var _loc_7:* = new TextField();
            if (param6 != 0)
            {
                _loc_7.width = param6;
            }
            var _loc_8:* = new TextFormat(param4, param2);
            new TextFormat(param4, param2).align = TextFormatAlign.LEFT;
            _loc_8.bold = param5;
            _loc_7.defaultTextFormat = _loc_8;
            _loc_7.textColor = param1;
            _loc_7.selectable = false;
            _loc_7.background = false;
            _loc_7.text = param3;
            _loc_7.autoSize = TextFieldAutoSize.LEFT;
            _loc_7.setTextFormat(_loc_8);
            return _loc_7;
        }// end function

        public static function createInputSingleLineTxt(param1:uint, param2:int, param3:Number, param4:Number) : TextField
        {
            var _loc_5:* = new TextField();
            var _loc_6:* = new TextFormat("", param2);
            new TextFormat("", param2).align = TextFormatAlign.LEFT;
            _loc_5.defaultTextFormat = _loc_6;
            _loc_5.textColor = param1;
            _loc_5.background = false;
            _loc_5.type = TextFieldType.INPUT;
            _loc_5.border = true;
            _loc_5.width = param3;
            _loc_5.height = param4;
            return _loc_5;
        }// end function

        public static function createBorderEditableSingleLineTxt(param1:uint, param2:uint, param3:int, param4:Number, param5:Number) : TextField
        {
            var _loc_6:* = new TextField();
            var _loc_7:* = new TextFormat("", param3);
            new TextFormat("", param3).align = TextFormatAlign.LEFT;
            _loc_6.defaultTextFormat = _loc_7;
            _loc_6.textColor = param1;
            _loc_6.background = false;
            _loc_6.type = TextFieldType.INPUT;
            _loc_6.selectable = true;
            _loc_6.border = true;
            _loc_6.background = true;
            _loc_6.backgroundColor = param2;
            _loc_6.width = param4;
            _loc_6.height = param5;
            return _loc_6;
        }// end function

        public static function createInputMutliLineTxt(param1:uint, param2:uint, param3:int, param4:Number, param5:Number, param6:Boolean = false, param7:Number = 0) : TextField
        {
            var _loc_8:* = new TextField();
            var _loc_9:* = new TextFormat("宋体", param3);
            if (param6)
            {
                _loc_8.border = true;
                _loc_8.borderColor = param7;
            }
            _loc_9.align = TextFormatAlign.LEFT;
            _loc_8.defaultTextFormat = _loc_9;
            _loc_8.textColor = param1;
            _loc_8.type = TextFieldType.INPUT;
            _loc_8.background = true;
            _loc_8.backgroundColor = param2;
            _loc_8.width = param4;
            _loc_8.height = param5;
            _loc_8.multiline = true;
            _loc_8.wordWrap = true;
            return _loc_8;
        }// end function

        public static function createMutliLineTxt(param1:uint, param2:int, param3:Number, param4:Number) : TextField
        {
            var _loc_5:* = new TextField();
            var _loc_6:* = new TextFormat("", param2);
            new TextFormat("", param2).align = TextFormatAlign.LEFT;
            _loc_5.defaultTextFormat = _loc_6;
            _loc_5.textColor = param1;
            _loc_5.selectable = false;
            _loc_5.width = param3;
            _loc_5.height = param4;
            _loc_5.multiline = true;
            _loc_5.wordWrap = true;
            return _loc_5;
        }// end function

        public static function secondToTimeFomat(param1:int) : String
        {
            var _loc_2:* = param1 % 60;
            var _loc_3:String = "";
            var _loc_4:String = "";
            if (_loc_2 < 10)
            {
                _loc_3 = "0" + _loc_2;
            }
            else
            {
                _loc_3 = _loc_2 + "";
            }
            var _loc_5:* = param1 / 60;
            if (param1 / 60 < 10)
            {
                _loc_4 = "0" + _loc_5;
            }
            else
            {
                _loc_4 = "" + _loc_5;
            }
            return _loc_4 + ":" + _loc_3;
        }// end function

    }
}

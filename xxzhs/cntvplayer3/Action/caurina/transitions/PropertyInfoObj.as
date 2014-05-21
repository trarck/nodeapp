package caurina.transitions
{

    public class PropertyInfoObj extends Object
    {
        public var modifierParameters:Array;
        public var isSpecialProperty:Boolean;
        public var valueComplete:Number;
        public var modifierFunction:Function;
        public var extra:Object;
        public var valueStart:Number;
        public var hasModifier:Boolean;
        public var arrayIndex:Number;
        public var originalValueComplete:Object;

        public function PropertyInfoObj(param1:Number, param2:Number, param3:Object, param4:Number, param5:Object, param6:Boolean, param7:Function, param8:Array)
        {
            valueStart = param1;
            valueComplete = param2;
            originalValueComplete = param3;
            arrayIndex = param4;
            extra = param5;
            isSpecialProperty = param6;
            hasModifier = Boolean(param7);
            modifierFunction = param7;
            modifierParameters = param8;
            return;
        }// end function

        public function toString() : String
        {
            var _loc_1:String = "\n[PropertyInfoObj ";
            _loc_1 = _loc_1 + ("valueStart:" + String(valueStart));
            _loc_1 = _loc_1 + ", ";
            _loc_1 = _loc_1 + ("valueComplete:" + String(valueComplete));
            _loc_1 = _loc_1 + ", ";
            _loc_1 = _loc_1 + ("originalValueComplete:" + String(originalValueComplete));
            _loc_1 = _loc_1 + ", ";
            _loc_1 = _loc_1 + ("arrayIndex:" + String(arrayIndex));
            _loc_1 = _loc_1 + ", ";
            _loc_1 = _loc_1 + ("extra:" + String(extra));
            _loc_1 = _loc_1 + ", ";
            _loc_1 = _loc_1 + ("isSpecialProperty:" + String(isSpecialProperty));
            _loc_1 = _loc_1 + ", ";
            _loc_1 = _loc_1 + ("hasModifier:" + String(hasModifier));
            _loc_1 = _loc_1 + ", ";
            _loc_1 = _loc_1 + ("modifierFunction:" + String(modifierFunction));
            _loc_1 = _loc_1 + ", ";
            _loc_1 = _loc_1 + ("modifierParameters:" + String(modifierParameters));
            _loc_1 = _loc_1 + "]\n";
            return _loc_1;
        }// end function

        public function clone() : PropertyInfoObj
        {
            var _loc_1:* = new PropertyInfoObj(valueStart, valueComplete, originalValueComplete, arrayIndex, extra, isSpecialProperty, modifierFunction, modifierParameters);
            return _loc_1;
        }// end function

    }
}

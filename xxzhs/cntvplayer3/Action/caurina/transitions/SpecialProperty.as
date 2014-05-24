package caurina.transitions
{

    public class SpecialProperty extends Object
    {
        public var parameters:Array;
        public var getValue:Function;
        public var preProcess:Function;
        public var setValue:Function;

        public function SpecialProperty(param1:Function, param2:Function, param3:Array = null, param4:Function = null)
        {
            getValue = param1;
            setValue = param2;
            parameters = param3;
            preProcess = param4;
            return;
        }// end function

        public function toString() : String
        {
            var _loc_1:String = "";
            _loc_1 = _loc_1 + "[SpecialProperty ";
            _loc_1 = _loc_1 + ("getValue:" + String(getValue));
            _loc_1 = _loc_1 + ", ";
            _loc_1 = _loc_1 + ("setValue:" + String(setValue));
            _loc_1 = _loc_1 + ", ";
            _loc_1 = _loc_1 + ("parameters:" + String(parameters));
            _loc_1 = _loc_1 + ", ";
            _loc_1 = _loc_1 + ("preProcess:" + String(preProcess));
            _loc_1 = _loc_1 + "]";
            return _loc_1;
        }// end function

    }
}

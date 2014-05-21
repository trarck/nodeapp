package com.cntv.common.model.vo
{

    public class StatusVO extends Object
    {
        public var type:int;
        public var isAutoHide:Boolean;
        public var msg:String;

        public function StatusVO(param1:String, param2:int, param3:Boolean = false)
        {
            this.msg = param1;
            this.type = param2;
            this.isAutoHide = param3;
            return;
        }// end function

    }
}

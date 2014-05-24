package com.cntv.common.model.proxy
{
    import com.puremvc.model.*;
    import flash.utils.*;

    public class GetSubAddProxy extends XMLProxy
    {
        private var parent:GetADDataProxy;
        private var mark:Number;
        private var timeOutCheck:Timer;

        public function GetSubAddProxy(param1:GetADDataProxy, param2:Number, param3:String)
        {
            this.parent = param1;
            this.mark = param2;
            sendHttpRequest(unescape(param3));
            return;
        }// end function

        override protected function throwDataException() : void
        {
            this.parent.getSubAdComp(this.mark, null);
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            this.parent.getSubAdComp(this.mark, null);
            return;
        }// end function

        override protected function loadCompleted(param1:XML) : void
        {
            this.parent.getSubAdComp(this.mark, param1.children()[0]);
            return;
        }// end function

    }
}

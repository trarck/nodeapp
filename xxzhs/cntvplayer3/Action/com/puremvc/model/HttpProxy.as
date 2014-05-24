package com.puremvc.model
{
    import com.serialization.json.*;
    import com.utils.net.request.*;

    public class HttpProxy extends CommonProxy
    {

        public function HttpProxy(param1:String = null, param2:Object = null)
        {
            super(param1, param2);
            return;
        }// end function

        protected function sendHttpRequest(param1:String, param2:Object = null, param3:Boolean = false) : void
        {
            new HttpRequest(new AttributeVo(param1, param2, param3), this.completeHandler, this.exceptionHandler);
            return;
        }// end function

        private function exceptionHandler(param1:String) : void
        {
            this.throwRequestException(param1);
            return;
        }// end function

        protected function throwRequestException(param1:String) : void
        {
            return;
        }// end function

        protected function throwDataException() : void
        {
            return;
        }// end function

        protected function completeHandler(param1:String) : void
        {
            var resultObj:Object;
            var result:* = param1;
            try
            {
                resultObj = JSON.decode(result);
            }
            catch (e:Error)
            {
                throwDataException();
                return;
            }
            this.loadCompleted(resultObj);
            return;
        }// end function

        protected function loadCompleted(param1:Object) : void
        {
            return;
        }// end function

    }
}

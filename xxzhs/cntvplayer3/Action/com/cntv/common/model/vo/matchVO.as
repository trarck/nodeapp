package com.cntv.common.model.vo
{

    public class matchVO extends Object
    {
        public var isPrecise:Boolean = false;
        public var options:Array;
        public var totalTime:Number = 0;

        public function matchVO(param1:Object)
        {
            this.options = new Array();
            if (param1.child != null && param1.child == "yes")
            {
                this.options = param1.children;
            }
            else if (param1.parent != null && param1.parent == "yes")
            {
                this.options = param1.parents;
                this.isPrecise = true;
            }
            return;
        }// end function

    }
}

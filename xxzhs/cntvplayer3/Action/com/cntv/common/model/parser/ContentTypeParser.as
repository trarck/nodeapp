package com.cntv.common.model.parser
{
    import com.cntv.common.model.vo.*;

    public class ContentTypeParser extends Object
    {

        public function ContentTypeParser()
        {
            return;
        }// end function

        public static function parseType(param1:String) : String
        {
            switch(param1)
            {
                case "flv":
                case "FLV":
                case "mp4":
                case "MP4":
                {
                    return ADVO.TYPE_VIDEO;
                }
                case "jpg":
                case "JPG":
                case "png":
                case "PNG":
                {
                    return ADVO.TYPE_IMAGE;
                }
                case "swf":
                case "SWF":
                {
                    return ADVO.TYPE_SWF;
                }
                default:
                {
                    break;
                }
            }
            return param1;
        }// end function

    }
}

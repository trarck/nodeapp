package com.conviva.utils
{

    public class LivePassVersion extends Object
    {
        public static const VERSION_MAJOR:int = 2;
        public static const VERSION_MINOR:int = 63;
        public static const VERSION_RELEASE:int = 0;
        public static const VERSION_SVN:int = 65809;
        public static const VERSION_LOGO:String = "Conviva LivePass version 2.63.0.65809";

        public function LivePassVersion()
        {
            Utils.ReportError("LivePassVersion: is an all-static class");
            return;
        }// end function

        public static function get versionStr() : String
        {
            return version3Str + "." + VERSION_SVN;
        }// end function

        public static function get version3Str() : String
        {
            return VERSION_MAJOR + "." + VERSION_MINOR + "." + VERSION_RELEASE;
        }// end function

        public static function get versionLogo() : String
        {
            return VERSION_LOGO;
        }// end function

    }
}

package com.conviva.utils
{

    public class ConvivaStatus extends Error
    {
        public static const SUCCESS:int = 0;
        public static const REFUSED_BY_POLICY:int = 4;
        public static const REFUSED_RESOURCES_NOT_AVAILABLE:int = 5;
        public static const REFUSED_RESOURCE_MISMATCH:int = 6;
        public static const FAULT_COMMUNICATION_BETWEEN_CLIENT_GATEWAY:int = 32;
        public static const FAULT_COMMUNICATION_BETWEEN_GATEWAY_RCC:int = -2;
        public static const WARNING_OK:int = 0;
        public static const WARNING_UNKNOWN_RESOURCE:int = 1;
        public static const WARNING_NO_MATCHING_SEQUENCING_POLICY:int = 2;
        public static const WARNING_MBR_POLICY_CONFIGURATION_ERROR:int = 4;
        public static const WARNING_OBSOLETE_SELECT_RESOURCE:int = 8;

        public function ConvivaStatus(param1:String)
        {
            super(param1);
            return;
        }// end function

    }
}

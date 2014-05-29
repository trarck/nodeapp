package com.cntv.common.model.proxy
{
    import com.cntv.common.*;
    import com.cntv.common.model.*;
    import com.puremvc.model.*;

    public class LoadLanguageProxy extends XMLProxy
    {
        private var appFacade:ApplicationFacade;
        public static const NAME:String = "LoadLanguageProxy";

        public function LoadLanguageProxy()
        {
            super(NAME);
            this.appFacade = ApplicationFacade.getInstance(Main.NAME);
            if (ModelLocator.getInstance().paramVO.languageConfig != null && ModelLocator.getInstance().paramVO.languageConfig != "")
            {
                sendHttpRequest(ModelLocator.getInstance().paramVO.languageConfig);
            }
            else
            {
                this.loadCompleted(null);
            }
            return;
        }// end function

        override protected function loadCompleted(param1:XML) : void
        {
            if (param1 != null)
            {
                ModelLocator.getInstance().i18n.setOtherLanguage(param1);
            }
            this.appFacade.sendNotification(ApplicationFacade.NOTI_GET_LANGUAGE);
            return;
        }// end function

        override protected function throwDataException() : void
        {
            this.loadCompleted(null);
            return;
        }// end function

        override protected function throwRequestException(param1:String) : void
        {
            this.loadCompleted(null);
            return;
        }// end function

    }
}

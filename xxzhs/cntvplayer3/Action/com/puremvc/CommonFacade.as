package com.puremvc
{
    import org.puremvc.as3.multicore.core.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;

    public class CommonFacade extends Object implements IFacade
    {
        protected var controller:IController;
        protected var model:IModel;
        protected var view:IView;
        protected var multitonKey:String;
        protected const MULTITON_MSG:String = "Facade instance for this Multiton key already constructed!";
        static var instanceMap:Array = new Array();

        public function CommonFacade(param1:String)
        {
            if (instanceMap[param1] != null)
            {
                throw Error(this.MULTITON_MSG);
            }
            this.initializeNotifier(param1);
            instanceMap[this.multitonKey] = this;
            this.initializeFacade();
            return;
        }// end function

        protected function initializeFacade() : void
        {
            this.initializeModel();
            this.initializeController();
            this.initializeView();
            return;
        }// end function

        protected function initializeController() : void
        {
            if (this.controller != null)
            {
                return;
            }
            this.controller = Controller.getInstance(this.multitonKey);
            return;
        }// end function

        protected function initializeModel() : void
        {
            if (this.model != null)
            {
                return;
            }
            this.model = Model.getInstance(this.multitonKey);
            return;
        }// end function

        protected function initializeView() : void
        {
            if (this.view != null)
            {
                return;
            }
            this.view = View.getInstance(this.multitonKey);
            return;
        }// end function

        public function registerCommand(param1:String, param2:Class) : void
        {
            this.controller.registerCommand(param1, param2);
            return;
        }// end function

        public function removeCommand(param1:String) : void
        {
            this.controller.removeCommand(param1);
            return;
        }// end function

        public function hasCommand(param1:String) : Boolean
        {
            return this.controller.hasCommand(param1);
        }// end function

        public function registerProxy(param1:IProxy) : void
        {
            this.model.registerProxy(param1);
            return;
        }// end function

        public function retrieveProxy(param1:String) : IProxy
        {
            return this.model.retrieveProxy(param1);
        }// end function

        public function removeProxy(param1:String) : IProxy
        {
            var _loc_2:IProxy = null;
            if (this.model != null)
            {
                _loc_2 = this.model.removeProxy(param1);
            }
            return _loc_2;
        }// end function

        public function hasProxy(param1:String) : Boolean
        {
            return this.model.hasProxy(param1);
        }// end function

        public function registerMediator(param1:IMediator) : void
        {
            if (this.view != null)
            {
                this.view.registerMediator(param1);
            }
            return;
        }// end function

        public function retrieveMediator(param1:String) : IMediator
        {
            return this.view.retrieveMediator(param1) as IMediator;
        }// end function

        public function removeMediator(param1:String) : IMediator
        {
            var _loc_2:IMediator = null;
            if (this.view != null)
            {
                _loc_2 = this.view.removeMediator(param1);
            }
            return _loc_2;
        }// end function

        public function hasMediator(param1:String) : Boolean
        {
            return this.view.hasMediator(param1);
        }// end function

        public function sendNotification(param1:String, param2:Object = null, param3:String = null) : void
        {
            this.notifyObservers(new Notification(param1, param2, param3));
            return;
        }// end function

        public function notifyObservers(param1:INotification) : void
        {
            if (this.view != null)
            {
                this.view.notifyObservers(param1);
            }
            return;
        }// end function

        public function initializeNotifier(param1:String) : void
        {
            this.multitonKey = param1;
            return;
        }// end function

        public static function getInstance(param1:String) : IFacade
        {
            if (instanceMap[param1] == null)
            {
                instanceMap[param1] = new CommonFacade(param1);
            }
            return instanceMap[param1];
        }// end function

        public static function hasCore(param1:String) : Boolean
        {
            return instanceMap[param1] != null;
        }// end function

        public static function removeCore(param1:String) : void
        {
            if (instanceMap[param1] == null)
            {
                return;
            }
            Model.removeModel(param1);
            View.removeView(param1);
            Controller.removeController(param1);
            delete instanceMap[param1];
            return;
        }// end function

    }
}

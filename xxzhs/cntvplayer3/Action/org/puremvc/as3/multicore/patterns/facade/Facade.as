package org.puremvc.as3.multicore.patterns.facade
{
    import org.puremvc.as3.multicore.core.*;
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;

    public class Facade extends Object implements IFacade
    {
        protected var multitonKey:String;
        protected var controller:IController;
        protected const MULTITON_MSG:String = "Facade instance for this Multiton key already constructed!";
        protected var model:IModel;
        protected var view:IView;
        static var instanceMap:Array = new Array();

        public function Facade(param1:String)
        {
            if (instanceMap[param1] != null)
            {
                throw Error(MULTITON_MSG);
            }
            initializeNotifier(param1);
            instanceMap[multitonKey] = this;
            initializeFacade();
            return;
        }// end function

        public function removeProxy(param1:String) : IProxy
        {
            var _loc_2:IProxy = null;
            if (model != null)
            {
                _loc_2 = model.removeProxy(param1);
            }
            return _loc_2;
        }// end function

        public function registerProxy(param1:IProxy) : void
        {
            model.registerProxy(param1);
            return;
        }// end function

        protected function initializeController() : void
        {
            if (controller != null)
            {
                return;
            }
            controller = Controller.getInstance(multitonKey);
            return;
        }// end function

        protected function initializeFacade() : void
        {
            initializeModel();
            initializeController();
            initializeView();
            return;
        }// end function

        public function retrieveProxy(param1:String) : IProxy
        {
            return model.retrieveProxy(param1);
        }// end function

        public function sendNotification(param1:String, param2:Object = null, param3:String = null) : void
        {
            notifyObservers(new Notification(param1, param2, param3));
            return;
        }// end function

        public function notifyObservers(param1:INotification) : void
        {
            if (view != null)
            {
                view.notifyObservers(param1);
            }
            return;
        }// end function

        protected function initializeView() : void
        {
            if (view != null)
            {
                return;
            }
            view = View.getInstance(multitonKey);
            return;
        }// end function

        public function retrieveMediator(param1:String) : IMediator
        {
            return view.retrieveMediator(param1) as IMediator;
        }// end function

        public function initializeNotifier(param1:String) : void
        {
            multitonKey = param1;
            return;
        }// end function

        public function removeMediator(param1:String) : IMediator
        {
            var _loc_2:IMediator = null;
            if (view != null)
            {
                _loc_2 = view.removeMediator(param1);
            }
            return _loc_2;
        }// end function

        public function hasCommand(param1:String) : Boolean
        {
            return controller.hasCommand(param1);
        }// end function

        public function removeCommand(param1:String) : void
        {
            controller.removeCommand(param1);
            return;
        }// end function

        public function registerCommand(param1:String, param2:Class) : void
        {
            controller.registerCommand(param1, param2);
            return;
        }// end function

        public function hasMediator(param1:String) : Boolean
        {
            return view.hasMediator(param1);
        }// end function

        public function registerMediator(param1:IMediator) : void
        {
            if (view != null)
            {
                view.registerMediator(param1);
            }
            return;
        }// end function

        protected function initializeModel() : void
        {
            if (model != null)
            {
                return;
            }
            model = Model.getInstance(multitonKey);
            return;
        }// end function

        public function hasProxy(param1:String) : Boolean
        {
            return model.hasProxy(param1);
        }// end function

        public static function hasCore(param1:String) : Boolean
        {
            return instanceMap[param1] != null;
        }// end function

        public static function getInstance(param1:String) : IFacade
        {
            if (instanceMap[param1] == null)
            {
                instanceMap[param1] = new Facade(param1);
            }
            return instanceMap[param1];
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

package org.puremvc.as3.multicore.core
{
    import org.puremvc.as3.multicore.interfaces.*;
    import org.puremvc.as3.multicore.patterns.observer.*;

    public class View extends Object implements IView
    {
        protected const MULTITON_MSG:String = "View instance for this Multiton key already constructed!";
        protected var multitonKey:String;
        protected var observerMap:Array;
        protected var mediatorMap:Array;
        static var instanceMap:Array = new Array();

        public function View(param1:String)
        {
            if (instanceMap[param1] != null)
            {
                throw Error(MULTITON_MSG);
            }
            multitonKey = param1;
            instanceMap[multitonKey] = this;
            mediatorMap = new Array();
            observerMap = new Array();
            initializeView();
            return;
        }// end function

        public function removeObserver(param1:String, param2:Object) : void
        {
            var _loc_3:* = observerMap[param1] as Array;
            var _loc_4:int = 0;
            while (_loc_4 < _loc_3.length)
            {
                
                if (Observer(_loc_3[_loc_4]).compareNotifyContext(param2) == true)
                {
                    _loc_3.splice(_loc_4, 1);
                    break;
                }
                _loc_4++;
            }
            if (_loc_3.length == 0)
            {
                delete observerMap[param1];
            }
            return;
        }// end function

        public function hasMediator(param1:String) : Boolean
        {
            return mediatorMap[param1] != null;
        }// end function

        public function notifyObservers(param1:INotification) : void
        {
            var _loc_2:Array = null;
            var _loc_3:Array = null;
            var _loc_4:IObserver = null;
            var _loc_5:Number = NaN;
            if (observerMap[param1.getName()] != null)
            {
                _loc_2 = observerMap[param1.getName()] as Array;
                _loc_3 = new Array();
                _loc_5 = 0;
                while (_loc_5 < _loc_2.length)
                {
                    
                    _loc_4 = _loc_2[_loc_5] as IObserver;
                    _loc_3.push(_loc_4);
                    _loc_5 = _loc_5 + 1;
                }
                _loc_5 = 0;
                while (_loc_5 < _loc_3.length)
                {
                    
                    _loc_4 = _loc_3[_loc_5] as IObserver;
                    _loc_4.notifyObserver(param1);
                    _loc_5 = _loc_5 + 1;
                }
            }
            return;
        }// end function

        protected function initializeView() : void
        {
            return;
        }// end function

        public function registerMediator(param1:IMediator) : void
        {
            var _loc_3:Observer = null;
            var _loc_4:Number = NaN;
            if (mediatorMap[param1.getMediatorName()] != null)
            {
                return;
            }
            param1.initializeNotifier(multitonKey);
            mediatorMap[param1.getMediatorName()] = param1;
            var _loc_2:* = param1.listNotificationInterests();
            if (_loc_2.length > 0)
            {
                _loc_3 = new Observer(param1.handleNotification, param1);
                _loc_4 = 0;
                while (_loc_4 < _loc_2.length)
                {
                    
                    registerObserver(_loc_2[_loc_4], _loc_3);
                    _loc_4 = _loc_4 + 1;
                }
            }
            param1.onRegister();
            return;
        }// end function

        public function removeMediator(param1:String) : IMediator
        {
            var _loc_3:Array = null;
            var _loc_4:Number = NaN;
            var _loc_2:* = mediatorMap[param1] as IMediator;
            if (_loc_2)
            {
                _loc_3 = _loc_2.listNotificationInterests();
                _loc_4 = 0;
                while (_loc_4 < _loc_3.length)
                {
                    
                    removeObserver(_loc_3[_loc_4], _loc_2);
                    _loc_4 = _loc_4 + 1;
                }
                delete mediatorMap[param1];
                _loc_2.onRemove();
            }
            return _loc_2;
        }// end function

        public function registerObserver(param1:String, param2:IObserver) : void
        {
            if (observerMap[param1] != null)
            {
                observerMap[param1].push(param2);
            }
            else
            {
                observerMap[param1] = [param2];
            }
            return;
        }// end function

        public function retrieveMediator(param1:String) : IMediator
        {
            return mediatorMap[param1];
        }// end function

        public static function removeView(param1:String) : void
        {
            delete instanceMap[param1];
            return;
        }// end function

        public static function getInstance(param1:String) : IView
        {
            if (instanceMap[param1] == null)
            {
                instanceMap[param1] = new View(param1);
            }
            return instanceMap[param1];
        }// end function

    }
}

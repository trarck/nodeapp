package com.conviva.utils
{

    public class XmlElement extends Object
    {
        private var _xelem:XML;

        public function XmlElement()
        {
            return;
        }// end function

        public function get xelem() : XML
        {
            return this._xelem;
        }// end function

        public function ToStr() : String
        {
            return Lang.XmlToString(this._xelem);
        }// end function

        public function GetElements(param1:String) : ListCS
        {
            var _loc_3:XML = null;
            var _loc_4:XML = null;
            var _loc_2:* = new ListCS();
            for each (_loc_3 in this._xelem.children())
            {
                
                if (_loc_3.name() == param1)
                {
                    _loc_2.Add(XmlElement.FromRepr(_loc_3));
                }
            }
            if (_loc_2.Count > 0)
            {
                return _loc_2;
            }
            for each (_loc_4 in this._xelem..[param1])
            {
                
                _loc_2.Add(XmlElement.FromRepr(_loc_4));
            }
            return _loc_2;
        }// end function

        public function GetName() : String
        {
            if (this._xelem == null)
            {
                return null;
            }
            var _loc_1:String = null;
            _loc_1 = this._xelem.name();
            return _loc_1;
        }// end function

        public function GetAttribute(param1:String) : String
        {
            if (this._xelem == null)
            {
                return null;
            }
            var _loc_2:String = null;
            var _loc_3:* = this._xelem[param1];
            if (_loc_3.length() > 0)
            {
                _loc_2 = _loc_3[0].toString();
            }
            return _loc_2;
        }// end function

        public function GetValue() : String
        {
            var _loc_1:String = null;
            if (this._xelem != null)
            {
                _loc_1 = this._xelem.toString();
            }
            if (_loc_1 == "")
            {
                _loc_1 = null;
            }
            return _loc_1;
        }// end function

        public function GetAltAffinity() : int
        {
            var _loc_1:int = 0;
            try
            {
                _loc_1 = Math.max(0, Lang.parseInt(this.GetAttribute("affinity")));
            }
            catch (e:Error)
            {
            }
            return _loc_1;
        }// end function

        public function GetAltName() : String
        {
            var _loc_1:String = null;
            try
            {
                _loc_1 = this.GetAttribute("name");
            }
            catch (e:Error)
            {
            }
            return _loc_1;
        }// end function

        public function FilterAlternatives(param1:String) : XmlElement
        {
            var _loc_3:XML = null;
            var _loc_2:* = this._xelem.copy();
            Utils.PushBreadCrumb("FA:0");
            _loc_2.setChildren(new XMLList());
            Utils.PushBreadCrumb("FA:1");
            for each (_loc_3 in this._xelem.children())
            {
                
                if (_loc_3.name() != "alternative")
                {
                    _loc_2.appendChild(_loc_3);
                    continue;
                }
                if (_loc_3.@name == null || _loc_3.@name.length() == 0)
                {
                    continue;
                }
                if (_loc_3.@name.toString() == param1)
                {
                    _loc_2.appendChild(_loc_3);
                    continue;
                }
            }
            Utils.PushBreadCrumb("FA:10");
            return XmlElement.FromRepr(_loc_2);
        }// end function

        public static function FromStr(param1:String) : XmlElement
        {
            if (param1 == null)
            {
                return null;
            }
            return XmlElement.FromRepr(Lang.StringToXml(param1));
        }// end function

        public static function FromRepr(param1:XML) : XmlElement
        {
            if (param1 == null)
            {
                return null;
            }
            var _loc_2:* = new XmlElement;
            _loc_2._xelem = param1;
            return _loc_2;
        }// end function

    }
}

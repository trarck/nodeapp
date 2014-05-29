package com.serialization.json
{

    public class JSONTokenizer extends Object
    {
        private var obj:Object;
        private var jsonString:String;
        private var loc:int;
        private var ch:String;

        public function JSONTokenizer(param1:String)
        {
            this.jsonString = param1;
            this.loc = 0;
            this.nextChar();
            return;
        }// end function

        public function getNextToken() : JSONToken
        {
            var _loc_2:String = null;
            var _loc_3:String = null;
            var _loc_4:String = null;
            var _loc_1:* = new JSONToken();
            this.skipIgnored();
            switch(this.ch)
            {
                case "{":
                {
                    _loc_1.type = JSONTokenType.LEFT_BRACE;
                    _loc_1.value = "{";
                    this.nextChar();
                    break;
                }
                case "}":
                {
                    _loc_1.type = JSONTokenType.RIGHT_BRACE;
                    _loc_1.value = "}";
                    this.nextChar();
                    break;
                }
                case "[":
                {
                    _loc_1.type = JSONTokenType.LEFT_BRACKET;
                    _loc_1.value = "[";
                    this.nextChar();
                    break;
                }
                case "]":
                {
                    _loc_1.type = JSONTokenType.RIGHT_BRACKET;
                    _loc_1.value = "]";
                    this.nextChar();
                    break;
                }
                case ",":
                {
                    _loc_1.type = JSONTokenType.COMMA;
                    _loc_1.value = ",";
                    this.nextChar();
                    break;
                }
                case ":":
                {
                    _loc_1.type = JSONTokenType.COLON;
                    _loc_1.value = ":";
                    this.nextChar();
                    break;
                }
                case "t":
                {
                    _loc_2 = "t" + this.nextChar() + this.nextChar() + this.nextChar();
                    if (_loc_2 == "true")
                    {
                        _loc_1.type = JSONTokenType.TRUE;
                        _loc_1.value = true;
                        this.nextChar();
                    }
                    else
                    {
                        this.parseError("Expecting \'true\' but found " + _loc_2);
                    }
                    break;
                }
                case "f":
                {
                    _loc_3 = "f" + this.nextChar() + this.nextChar() + this.nextChar() + this.nextChar();
                    if (_loc_3 == "false")
                    {
                        _loc_1.type = JSONTokenType.FALSE;
                        _loc_1.value = false;
                        this.nextChar();
                    }
                    else
                    {
                        this.parseError("Expecting \'false\' but found " + _loc_3);
                    }
                    break;
                }
                case "n":
                {
                    _loc_4 = "n" + this.nextChar() + this.nextChar() + this.nextChar();
                    if (_loc_4 == "null")
                    {
                        _loc_1.type = JSONTokenType.NULL;
                        _loc_1.value = null;
                        this.nextChar();
                    }
                    else
                    {
                        this.parseError("Expecting \'null\' but found " + _loc_4);
                    }
                    break;
                }
                case "\"":
                {
                    _loc_1 = this.readString();
                    break;
                }
                default:
                {
                    if (this.isDigit(this.ch) || this.ch == "-")
                    {
                        _loc_1 = this.readNumber();
                    }
                    else
                    {
                        if (this.ch == "")
                        {
                            return null;
                        }
                        this.parseError("Unexpected " + this.ch + " encountered");
                    }
                    break;
                }
            }
            return _loc_1;
        }// end function

        private function readString() : JSONToken
        {
            var _loc_3:String = null;
            var _loc_4:int = 0;
            var _loc_1:* = new JSONToken();
            _loc_1.type = JSONTokenType.STRING;
            var _loc_2:String = "";
            this.nextChar();
            while (this.ch != "\"" && this.ch != "")
            {
                
                if (this.ch == "\\")
                {
                    this.nextChar();
                    switch(this.ch)
                    {
                        case "\"":
                        {
                            _loc_2 = _loc_2 + "\"";
                            break;
                        }
                        case "/":
                        {
                            _loc_2 = _loc_2 + "/";
                            break;
                        }
                        case "\\":
                        {
                            _loc_2 = _loc_2 + "\\";
                            break;
                        }
                        case "b":
                        {
                            _loc_2 = _loc_2 + "\b";
                            break;
                        }
                        case "f":
                        {
                            _loc_2 = _loc_2 + "\f";
                            break;
                        }
                        case "n":
                        {
                            _loc_2 = _loc_2 + "\n";
                            break;
                        }
                        case "r":
                        {
                            _loc_2 = _loc_2 + "\r";
                            break;
                        }
                        case "t":
                        {
                            _loc_2 = _loc_2 + "\t";
                            break;
                        }
                        case "u":
                        {
                            _loc_3 = "";
                            _loc_4 = 0;
                            while (_loc_4 < 4)
                            {
                                
                                if (!this.isHexDigit(this.nextChar()))
                                {
                                    this.parseError(" Excepted a hex digit, but found: " + this.ch);
                                }
                                _loc_3 = _loc_3 + this.ch;
                                _loc_4++;
                            }
                            _loc_2 = _loc_2 + String.fromCharCode(parseInt(_loc_3, 16));
                            break;
                        }
                        default:
                        {
                            _loc_2 = _loc_2 + ("\\" + this.ch);
                            break;
                        }
                    }
                }
                else
                {
                    _loc_2 = _loc_2 + this.ch;
                }
                this.nextChar();
            }
            if (this.ch == "")
            {
                this.parseError("Unterminated string literal");
            }
            this.nextChar();
            _loc_1.value = _loc_2;
            return _loc_1;
        }// end function

        private function readNumber() : JSONToken
        {
            var _loc_1:* = new JSONToken();
            _loc_1.type = JSONTokenType.NUMBER;
            var _loc_2:String = "";
            if (this.ch == "-")
            {
                _loc_2 = _loc_2 + "-";
                this.nextChar();
            }
            if (!this.isDigit(this.ch))
            {
                this.parseError("Expecting a digit");
            }
            if (this.ch == "0")
            {
                _loc_2 = _loc_2 + this.ch;
                this.nextChar();
                if (this.isDigit(this.ch))
                {
                    this.parseError("A digit cannot immediately follow 0");
                }
            }
            else
            {
                while (this.isDigit(this.ch))
                {
                    
                    _loc_2 = _loc_2 + this.ch;
                    this.nextChar();
                }
            }
            if (this.ch == ".")
            {
                _loc_2 = _loc_2 + ".";
                this.nextChar();
                if (!this.isDigit(this.ch))
                {
                    this.parseError("Expecting a digit");
                }
                while (this.isDigit(this.ch))
                {
                    
                    _loc_2 = _loc_2 + this.ch;
                    this.nextChar();
                }
            }
            if (this.ch == "e" || this.ch == "E")
            {
                _loc_2 = _loc_2 + "e";
                this.nextChar();
                if (this.ch == "+" || this.ch == "-")
                {
                    _loc_2 = _loc_2 + this.ch;
                    this.nextChar();
                }
                if (!this.isDigit(this.ch))
                {
                    this.parseError("Scientific notation number needs exponent value");
                }
                while (this.isDigit(this.ch))
                {
                    
                    _loc_2 = _loc_2 + this.ch;
                    this.nextChar();
                }
            }
            var _loc_3:* = Number(_loc_2);
            if (isFinite(_loc_3) && !isNaN(_loc_3))
            {
                _loc_1.value = _loc_3;
                return _loc_1;
            }
            this.parseError("Number " + _loc_3 + " is not valid!");
            return null;
        }// end function

        private function nextChar() : String
        {
            var _loc_1:String = this;
            _loc_1.loc = this.loc + 1;
            var _loc_1:* = this.jsonString.charAt(this.loc++);
            this.ch = this.jsonString.charAt(this.loc++);
            return _loc_1;
        }// end function

        private function skipIgnored() : void
        {
            this.skipWhite();
            this.skipComments();
            this.skipWhite();
            return;
        }// end function

        private function skipComments() : void
        {
            if (this.ch == "/")
            {
                this.nextChar();
                switch(this.ch)
                {
                    case "/":
                    {
                        do
                        {
                            
                            this.nextChar();
                        }while (this.ch != "\n" && this.ch != "")
                        this.nextChar();
                        break;
                    }
                    case "*":
                    {
                        this.nextChar();
                        while (true)
                        {
                            
                            if (this.ch == "*")
                            {
                                this.nextChar();
                                if (this.ch == "/")
                                {
                                    this.nextChar();
                                    break;
                                }
                            }
                            else
                            {
                                this.nextChar();
                            }
                            if (this.ch == "")
                            {
                                this.parseError("Multi-line comment not closed");
                            }
                        }
                        break;
                    }
                    default:
                    {
                        this.parseError("Unexpected " + this.ch + " encountered (expecting \'/\' or \'*\' )");
                        break;
                    }
                }
            }
            return;
        }// end function

        private function skipWhite() : void
        {
            while (this.isWhiteSpace(this.ch))
            {
                
                this.nextChar();
            }
            return;
        }// end function

        private function isWhiteSpace(param1:String) : Boolean
        {
            return param1 == " " || param1 == "\t" || param1 == "\n";
        }// end function

        private function isDigit(param1:String) : Boolean
        {
            return param1 >= "0" && param1 <= "9";
        }// end function

        private function isHexDigit(param1:String) : Boolean
        {
            var _loc_2:* = param1.toUpperCase();
            return this.isDigit(param1) || _loc_2 >= "A" && _loc_2 <= "F";
        }// end function

        public function parseError(param1:String) : void
        {
            throw new JSONParseError(param1, this.loc, this.jsonString);
        }// end function

    }
}

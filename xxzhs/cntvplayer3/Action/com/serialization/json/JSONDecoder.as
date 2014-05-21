package com.serialization.json
{

    public class JSONDecoder extends Object
    {
        private var value:Object;
        private var tokenizer:JSONTokenizer;
        private var token:JSONToken;

        public function JSONDecoder(param1:String)
        {
            this.tokenizer = new JSONTokenizer(param1);
            this.nextToken();
            this.value = this.parseValue();
            return;
        }// end function

        public function getValue()
        {
            return this.value;
        }// end function

        private function nextToken() : JSONToken
        {
            var _loc_1:* = this.tokenizer.getNextToken();
            this.token = this.tokenizer.getNextToken();
            return _loc_1;
        }// end function

        private function parseArray() : Array
        {
            var _loc_1:* = new Array();
            this.nextToken();
            if (this.token.type == JSONTokenType.RIGHT_BRACKET)
            {
                return _loc_1;
            }
            while (true)
            {
                
                _loc_1.push(this.parseValue());
                this.nextToken();
                if (this.token.type == JSONTokenType.RIGHT_BRACKET)
                {
                    return _loc_1;
                }
                if (this.token.type == JSONTokenType.COMMA)
                {
                    this.nextToken();
                    continue;
                }
                this.tokenizer.parseError("Expecting ] or , but found " + this.token.value);
            }
            return null;
        }// end function

        private function parseObject() : Object
        {
            var _loc_2:String = null;
            var _loc_1:* = new Object();
            this.nextToken();
            if (this.token.type == JSONTokenType.RIGHT_BRACE)
            {
                return _loc_1;
            }
            while (true)
            {
                
                if (this.token.type == JSONTokenType.STRING)
                {
                    _loc_2 = String(this.token.value);
                    this.nextToken();
                    if (this.token.type == JSONTokenType.COLON)
                    {
                        this.nextToken();
                        _loc_1[_loc_2] = this.parseValue();
                        this.nextToken();
                        if (this.token.type == JSONTokenType.RIGHT_BRACE)
                        {
                            return _loc_1;
                        }
                        if (this.token.type == JSONTokenType.COMMA)
                        {
                            this.nextToken();
                        }
                        else
                        {
                            this.tokenizer.parseError("Expecting } or , but found " + this.token.value);
                        }
                    }
                    else
                    {
                        this.tokenizer.parseError("Expecting : but found " + this.token.value);
                    }
                    continue;
                }
                this.tokenizer.parseError("Expecting string but found " + this.token.value);
            }
            return null;
        }// end function

        private function parseValue() : Object
        {
            switch(this.token.type)
            {
                case JSONTokenType.LEFT_BRACE:
                {
                    return this.parseObject();
                }
                case JSONTokenType.LEFT_BRACKET:
                {
                    return this.parseArray();
                }
                case JSONTokenType.STRING:
                case JSONTokenType.NUMBER:
                case JSONTokenType.TRUE:
                case JSONTokenType.FALSE:
                case JSONTokenType.NULL:
                {
                    return this.token.value;
                }
                default:
                {
                    this.tokenizer.parseError("Unexpected " + this.token.value);
                    break;
                }
            }
            return null;
        }// end function

    }
}

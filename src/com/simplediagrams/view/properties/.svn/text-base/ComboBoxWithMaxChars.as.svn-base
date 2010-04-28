package com.simplediagrams.view.properties
{
    import mx.controls.ComboBox;

    public class ComboBoxWithMaxChars extends ComboBox
    {
        public function ComboBoxWithMaxChars()
        {
            super();
        }

        private var _maxCharsForTextInput:int;

        public function set maxCharsForTextInput(value:int):void
        {
            _maxCharsForTextInput = value;

            if (super.textInput != null && _maxCharsForTextInput > 0)
                super.textInput.maxChars = _maxCharsForTextInput;
        }

        public function get maxCharsForTextInput():int
        {
            return _maxCharsForTextInput;
        }

        override public function itemToLabel(item:Object):String
        {
            var label:String = super.itemToLabel(item);

            if (_maxCharsForTextInput > 0)
                label = label.substr(0, _maxCharsForTextInput);

            return label;
        }
    }
}

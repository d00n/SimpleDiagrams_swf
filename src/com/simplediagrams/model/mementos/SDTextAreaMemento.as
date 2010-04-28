package com.simplediagrams.model.mementos
{
	public class SDTextAreaMemento extends SDObjectMemento
	{
		
		
		public var styleName:String 
		public var text:String 
		public var fontSize:Number
		public var fontWeight:String 
		public var textAlign:String
			
		
		public function SDTextAreaMemento()
		{
		}
		
		public function clone():SDTextAreaMemento
		{		
			var memento:SDTextAreaMemento = new SDTextAreaMemento()
			this.cloneBaseProperties(memento)
							
			memento.styleName = styleName 
			memento.text = text 
			memento.fontSize = fontSize
			memento.fontWeight = fontWeight 
			memento.textAlign = textAlign
			
			return memento
			
		}
	}
}
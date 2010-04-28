package com.simplediagrams.model.mementos
{
	import flash.utils.ByteArray;

	public class SDImageMemento extends SDObjectMemento
	{
		
		public var imageData:ByteArray
		public var styleName:String
		public var origWidth:Number
		public var origHeight:Number
		
		
		public function SDImageMemento()
		{
		}
		
		
		
		public function clone():SDImageMemento
		{		
			var memento:SDImageMemento = new SDImageMemento()
			this.cloneBaseProperties(memento)
			
			//clone SDSymbolModel specific properties
			memento.imageData = imageData
			memento.styleName = styleName
			memento.origHeight = origHeight
			memento.origWidth = origWidth
			
			return memento
			
		}
		
		
	}
}
package com.simplediagrams.model.mementos
{
	public class SDLineMemento extends SDObjectMemento
	{
		
		public var startLineStyle:int
		public var endLineStyle:int
		public var lineWeight:int
		public var startX:Number
		public var startY:Number
		public var endX:Number
		public var endY:Number
		public var bendX:Number
		public var bendY:Number
		
		public function SDLineMemento()
		{
		}
		
		public function clone():SDLineMemento
		{		
			var memento:SDLineMemento = new SDLineMemento()
			this.cloneBaseProperties(memento)
			
			//clone SDSymbolModel specific properties
			
			memento.startLineStyle = startLineStyle
			memento.endLineStyle = endLineStyle
			memento.lineWeight = lineWeight
			memento.startX = startX
			memento.startY = startY
			memento.endX  = endX
			memento.endY = endY
			memento.bendX = bendX
			memento.bendY = bendY
				
			
			return memento
			
		}
	}
}
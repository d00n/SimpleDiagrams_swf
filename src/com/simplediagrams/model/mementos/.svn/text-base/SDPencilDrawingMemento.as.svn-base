package com.simplediagrams.model.mementos
{
	public class SDPencilDrawingMemento extends SDObjectMemento
	{
		
		public var linePath:String
		public var lineWeight:Number
		
		public function SDPencilDrawingMemento()
		{
		}
		
		public function clone():SDPencilDrawingMemento
		{		
			var memento:SDPencilDrawingMemento = new SDPencilDrawingMemento()
			this.cloneBaseProperties(memento)
			
			//clone SDSymbolModel specific properties
			memento.linePath = linePath
			memento.lineWeight = lineWeight
			
			return memento
			
		}
	}
}
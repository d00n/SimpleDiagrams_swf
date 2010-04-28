package com.simplediagrams.model.mementos
{
	
	//This memento is only meant to capture the ObjectHandles transform properties (width, height, x, y, rotation)
	
	public class TransformMemento
	{
		
		public var x:Number
		public var y:Number
		public var width:Number
		public var height:Number
		public var rotation:Number
		public var zIndex:Number
		public var color:Number
		
		public function TransformMemento()
		{
		}
		
		public function clone():TransformMemento
		{
			var memento:TransformMemento = new TransformMemento()
			memento.x = x
			memento.y = y
			memento.width = width
			memento.height = height
			memento.rotation = rotation
			memento.zIndex = zIndex
			memento.color = color
			return memento
		}
	}
}
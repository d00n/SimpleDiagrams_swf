package com.simplediagrams.model
{
	
	
	import com.simplediagrams.model.mementos.ITransformMemento;
	import com.simplediagrams.model.mementos.SDObjectMemento;
	import com.simplediagrams.model.mementos.SDPencilDrawingMemento;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.SDComponents.ISDComponent;
	import com.simplediagrams.view.SDComponents.SDPencilDrawing;

	[Bindable]	
	[Table(name='pencil_drawings')]
	public class SDPencilDrawingModel extends SDObjectModel
	{
		
		public var linePath:String = "";
		public var lineWeight:Number = 1;
		private var _startState:SDPencilDrawingMemento
				
		
		public function SDPencilDrawingModel()
		{
		}
					
		public override function createSDComponent():ISDComponent
		{
			var component:SDPencilDrawing = new SDPencilDrawing()
			component.objectModel = this
			this.sdComponent = component
			Logger.debug("component: " + component, this)
			return component
		}
	
		
		override public function getMemento():SDObjectMemento
		{
			var memento:SDPencilDrawingMemento = new SDPencilDrawingMemento()
			captureBasePropertiesInMemento(memento)
			
			//now record SDSymbolModel's specific properties into memento
			var mem:SDPencilDrawingMemento = SDPencilDrawingMemento(memento)
			mem.linePath = linePath 
			mem.lineWeight = lineWeight
			
			return memento 
		}
		
		
		override public function setMemento(memento:SDObjectMemento):void
		{
			//set base properties from memento
			this.setBasePropertiesFromMemento(memento)
			
			//now set SDSymbolModel specific properties from memento
			var mem:SDPencilDrawingMemento = SDPencilDrawingMemento(memento)
			this.linePath = mem.linePath
			this.lineWeight = mem.lineWeight
		}
		
	
		
		
		
				
	}
}
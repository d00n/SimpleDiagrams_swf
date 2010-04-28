package com.simplediagrams.commands
{
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.SDLineModel;
	import com.simplediagrams.model.mementos.SDLineMemento;
		
		/* This class handles the basic changes to the line style. 
		It doesn't handle positioning and changes to the arc...those 
		are handled in a different class. */
		
		public class ChangeLinePositionCommand extends UndoRedoCommand
		{
			private var _diagramModel:DiagramModel
			
			public var sdID:Number
			public var fromState:SDLineMemento
			public var toState:SDLineMemento
			
			public function ChangeLinePositionCommand(diagramModel:DiagramModel)
			{
				_diagramModel = diagramModel					
			}
			
			override public function execute():void
			{	
				redo()
			}
			
			override public function redo():void
			{								
				var line:SDLineModel = _diagramModel.getModelByID(sdID) as SDLineModel
				if (line && toState)
				{
					line.setMemento(toState)
				}
			}
			
			override public function undo():void
			{						
				var line:SDLineModel = _diagramModel.getModelByID(sdID) as SDLineModel
				if (line && fromState)
				{
					line.setMemento(fromState)
				}
			}
			
			
			
		}
}
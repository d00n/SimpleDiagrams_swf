package com.simplediagrams.commands
{
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.SDLineModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.model.mementos.SDLineMemento;
	import com.simplediagrams.util.Logger
	
	/* This class handles the basic changes to the line style. 
	It doesn't handle positioning and changes to the arc...those 
	are handled in a different class. */
	
	public class ChangeLineStyleCommand extends UndoRedoCommand
	{
		private var _diagramModel:DiagramModel
		private var _mementosArr:Array = []//holds mementos as {sdID:(sdID of sdObjectModel), fromState:SDLineMemento, toState:SDLineMemento}	
		
		public var startLineStyle:Number = -1
		public var endLineStyle:Number = -1
		public var lineWeight:Number = -1
				
		/* Note that the lines to be changes come in as an array, since multiple lines may be selected 
		The style values passed into this function are the style we want to change all lines to.
		So, this command remembers the styles the lines were before the command, and also the settings they were changed to during this command
		*/		
		public function ChangeLineStyleCommand(diagramModel:DiagramModel)
		{
			_diagramModel = diagramModel	
			
			
			
		}
				
		override public function execute():void
		{	
			for each (var sdObjectModel:SDObjectModel in _diagramModel.selectedArray)
			{
				if (sdObjectModel is SDLineModel)
				{
					var sdLineModel:SDLineModel = SDLineModel(sdObjectModel)
					
					var fState:SDLineMemento = sdLineModel.getMemento() as SDLineMemento
					
					//do operations here
					Logger.debug("startLineStyle: " + startLineStyle,this)
					if (startLineStyle!=-1) sdLineModel.startLineStyle = startLineStyle
					if (endLineStyle!=-1) sdLineModel.endLineStyle = endLineStyle
					if (lineWeight!=-1) sdLineModel.lineWeight = lineWeight
					
					var tState:SDLineMemento = sdLineModel.getMemento() as SDLineMemento
					
					_mementosArr.push({sdID:sdLineModel.sdID, fromState:fState, toState:tState})
					
				}				
			}			
		}
		
		override public function redo():void
		{							
			for each (var obj:Object in _mementosArr)
			{
				var line:SDLineModel = _diagramModel.getModelByID(obj.sdID) as SDLineModel
				if (line)
				{
					line.setMemento(obj.toState)
				}
			}
		}
		
		override public function undo():void
		{						
			for each (var obj:Object in _mementosArr)
			{
				var line:SDLineModel = _diagramModel.getModelByID(obj.sdID) as SDLineModel
				if (line)
				{
					line.setMemento(obj.fromState)
				}
			}
		}
		
		
		
	}
}
package com.simplediagrams.commands
{
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.SDPencilDrawingModel;
	
	import mx.core.UIComponent;
	
	public class AddPencilDrawingCommand extends UndoRedoCommand
	{
		private var _diagramModel:DiagramModel
		public var sdID:Number = 0
		public var x:Number
		public var y:Number
		public var width:Number
		public var height:Number
		public var color:Number
		public var linePath:String
		
		public function AddPencilDrawingCommand(diagramModel:DiagramModel)
		{
			_diagramModel = diagramModel
			super();
		}
		
		override public function execute():void
		{	
			redo()
		}
		
		override public function undo():void
		{						
			_diagramModel.deleteSDObjectModelByID(sdID)		
		}
		
		override public function redo():void
		{		
			var newPencilDrawingModel:SDPencilDrawingModel = new SDPencilDrawingModel()		
			setProperties(newPencilDrawingModel)
			_diagramModel.addSDObjectModel(newPencilDrawingModel)
			//on the first execution, we get a fresh id...on later executions, use old id
			if (sdID!=0)
			{
				newPencilDrawingModel.sdID = sdID
			}
			else
			{				
				sdID = newPencilDrawingModel.sdID
			}
			UIComponent(newPencilDrawingModel.sdComponent).focusManager.getFocus()
			newPencilDrawingModel.captureStartState()
		}
		
		protected function setProperties(newPencilDrawingModel:SDPencilDrawingModel):void
		{
			newPencilDrawingModel.x = x
			newPencilDrawingModel.y = y
			newPencilDrawingModel.width = width
			newPencilDrawingModel.height = height
			newPencilDrawingModel.color = color
			newPencilDrawingModel.linePath = linePath
		}
	}
}
package com.simplediagrams.commands
{
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.SDLineModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.util.Logger;
	
	import mx.core.UIComponent;
	
	public class ChangeColorCommand extends UndoRedoCommand
	{
		private var _diagramModel:DiagramModel
		protected var _sdID:Number = 0
		protected var _previous_color:int
		public var color:Number
		
		public function ChangeColorCommand(diagramModel:DiagramModel, sdObjectModel:SDObjectModel)
		{
			_diagramModel = diagramModel;
			_sdID = sdObjectModel.sdID;
			_previous_color = sdObjectModel.color;
			super();
		}
		
		override public function execute():void
		{	
			redo()
		}
		
		override public function undo():void
		{						
			var sdObjectModel:SDObjectModel = _diagramModel.getModelByID(_sdID);
			if (sdObjectModel) {
				sdObjectModel.color = _previous_color;
			} else {
				Logger.error("Object lookup by sdID failed: " + _sdID, this);
			}
		}
		
		override public function redo():void
		{
			var sdObjectModel:SDObjectModel = _diagramModel.getModelByID(_sdID);
			if (sdObjectModel) {
				sdObjectModel.color = color;			
			} else {
				Logger.error("Object lookup by sdID failed: " + _sdID, this);
			}
		}
		
	}
}
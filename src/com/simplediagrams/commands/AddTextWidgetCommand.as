package com.simplediagrams.commands
{
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.SDTextAreaModel;
	
	import mx.core.UIComponent;
	
	public class AddTextWidgetCommand extends UndoRedoCommand
	{
		private var _diagramModel:DiagramModel
		public var sdID:Number = 0
		public var x:Number
		public var y:Number
		public var styleName:String
		public var maintainProportion:Boolean
		
		public function AddTextWidgetCommand(diagramModel:DiagramModel)
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
			
			
			var newSDTextAreaModel:SDTextAreaModel = new SDTextAreaModel()			
			setProperties(newSDTextAreaModel)
			_diagramModel.addSDObjectModel(newSDTextAreaModel)
			if (sdID!=0)
			{
				newSDTextAreaModel.sdID = sdID
			}
			else
			{				
				sdID = newSDTextAreaModel.sdID
			}
			UIComponent(newSDTextAreaModel.sdComponent).focusManager.getFocus()
			newSDTextAreaModel.captureStartState()
		}
		
		protected function setProperties(sdTextAreaModel:SDTextAreaModel):void
		{
			sdTextAreaModel.x = x
			sdTextAreaModel.y = y
			sdTextAreaModel.styleName = styleName
			sdTextAreaModel.maintainProportion = maintainProportion
		}
	}
}
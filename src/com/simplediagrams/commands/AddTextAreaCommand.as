package com.simplediagrams.commands
{
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.SDTextAreaModel;
	import com.simplediagrams.util.Logger
	import mx.core.UIComponent;
	
	public class AddTextAreaCommand extends UndoRedoCommand
	{
		private var _diagramModel:DiagramModel
		public var sdID:Number = 0
		public var x:Number
		public var y:Number
		public var styleName:String
		public var maintainProportion:Boolean
		public var width:int = 120
		public var height:int = 50
		public var textAlign:String
		public var fontSize:int
		public var fontWeight:String
		
		public function AddTextAreaCommand(diagramModel:DiagramModel)
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
			Logger.debug("Undoing add text area",this)
			_diagramModel.deleteSDObjectModelByID(sdID)		
		}
		
		override public function redo():void
		{		
			var newSDTextAreaModel:SDTextAreaModel = new SDTextAreaModel()			
			_diagramModel.addSDObjectModel(newSDTextAreaModel)
			setProperties(newSDTextAreaModel)
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
			sdTextAreaModel.width = width
			sdTextAreaModel.height = height
			sdTextAreaModel.styleName = styleName
			sdTextAreaModel.textAlign = textAlign
			sdTextAreaModel.fontSize = fontSize
			sdTextAreaModel.fontWeight = fontWeight
		}
	}
}
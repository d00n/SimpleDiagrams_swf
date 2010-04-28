package com.simplediagrams.commands
{
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.SDImageModel;
	import com.simplediagrams.util.Logger;
	
	import mx.core.UIComponent;
	
	public class AddImageItem extends UndoRedoCommand
	{
		private var _diagramModel:DiagramModel
		private var _sdID:Number = 0
		public var x:Number
		public var y:Number
			
		public function AddImageItem(diagramModel:DiagramModel)
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
			_diagramModel.deleteSDObjectModelByID(_sdID)		
		}
		
		override public function redo():void
		{			
			var newSDImageModel:SDImageModel = new SDImageModel()
								
			_diagramModel.addSDObjectModel(newSDImageModel)
			setProperties(newSDImageModel)
			if (_sdID!=0)
			{
				newSDImageModel.sdID = _sdID
			}
			else
			{				
				_sdID = newSDImageModel.sdID
			}
			UIComponent(newSDImageModel.sdComponent).focusManager.getFocus()
			newSDImageModel.captureStartState()
		}
		
		protected function setProperties(sdSymbolModel:SDImageModel):void
		{
			sdSymbolModel.x = x
			sdSymbolModel.y = y
		}
	}
}
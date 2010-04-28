package com.simplediagrams.commands
{
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.LibraryManager;
	import com.simplediagrams.model.SDSymbolModel;
	import com.simplediagrams.util.Logger;
	
	import mx.core.UIComponent;

	public class AddLibraryItemCommand extends UndoRedoCommand
	{
		private var _diagramModel:DiagramModel
		private var _libraryManager:LibraryManager
		private var _libraryName:String
		private var _symbolName:String
		private var _sdID:Number = 0
		public var x:Number
		public var y:Number
		public var textAlign:String
		public var fontSize:Number
		public var fontWeight:String
		public var textPosition:String
		public var color:Number;
		
		/* Adds a SDSymbolModel to the diagram. 
		* This class remembers the id first given to the symbol so that it can be restored correctly 
		*/
		
		public function get sdID():Number { return _sdID; }
		public function set sdID(value:Number):void { _sdID = value; }
		public function get libraryName():String { return _libraryName; }
		public function get symbolName():String { return _symbolName; }
		
		public function AddLibraryItemCommand(diagramModel:DiagramModel, libraryManager:LibraryManager, libraryName:String, symbolName:String)
		{
			_diagramModel = diagramModel
			_libraryManager = libraryManager
			_libraryName = libraryName
			_symbolName = symbolName
			super();
		}
		
		override public function execute():void
		{	
			redo()
		}
		
		override public function undo():void
		{						
			Logger.debug("undo() sdID: " + _sdID,this)
			_diagramModel.deleteSDObjectModelByID(_sdID)		
		}
		
		override public function redo():void
		{
			Logger.debug("redo() sdID: " + _sdID,this)
			var newSymbolModel:SDSymbolModel = _libraryManager.getSDObject(_libraryName, _symbolName) as SDSymbolModel		
			setProperties(newSymbolModel)			
			_diagramModel.addSDObjectModel(newSymbolModel)
			Logger.debug("after added newSymbolModel.sdID: " + newSymbolModel.sdID,this)
			if (_sdID!=0)
			{
				newSymbolModel.sdID = _sdID
			}
			else
			{				
				_sdID = newSymbolModel.sdID
			}
			
			Logger.debug("after adding sdID: " + _sdID,this)
			UIComponent(newSymbolModel.sdComponent).focusManager.getFocus()
		}
		
		protected function setProperties(sdSymbolModel:SDSymbolModel):void
		{
			sdSymbolModel.x = x
			sdSymbolModel.y = y
			sdSymbolModel.textAlign = textAlign
			sdSymbolModel.fontSize
			sdSymbolModel.fontWeight
			sdSymbolModel.textPosition
			sdSymbolModel.color = color;
		}
	}
}
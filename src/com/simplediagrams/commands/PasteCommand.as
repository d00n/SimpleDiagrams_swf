package com.simplediagrams.commands
{
	
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.util.Logger;
		
	public class PasteCommand extends UndoRedoCommand
	{
		protected var _diagramModel:DiagramModel
		
		public var pastedObjectsArr:Array //this is an array of clones derived from objects selected when cut or copy was selected
		
		public function PasteCommand(diagramModel:DiagramModel)
		{
			_diagramModel = diagramModel
		}
				
		override public function execute():void
		{	
			redo()
		}
		
		override public function undo():void
		{						
			for each (var sdObject:SDObjectModel in pastedObjectsArr)
			{
				_diagramModel.deleteSDObjectModelByID(sdObject.sdID)
			}
		}
		
		override public function redo():void
		{
			Logger.debug("paste redo() ",this)
			for each (var sdObjectToPaste:SDObjectModel in pastedObjectsArr)
			{	
				
				Logger.debug("sdObjectToPaste: " + sdObjectToPaste + "   sdObjectToPaste.sdID: " + sdObjectToPaste.sdID,this)
							
				if (sdObjectToPaste!=null)
				{
					sdObjectToPaste.x =  sdObjectToPaste.x + 50
					_diagramModel.addSDObjectModel(sdObjectToPaste)
					_diagramModel.addToSelected(sdObjectToPaste)			
				}
			}
						
		}
		
		
	}
}
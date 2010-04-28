package com.simplediagrams.commands
{
	
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.util.Logger;
	
	import flash.desktop.Clipboard;
	
	public class CutCommand extends UndoRedoCommand
	{
		protected var _diagramModel:DiagramModel		
		public var clonesArr:Array //holds cloned sdObjectModels 
		
		public function CutCommand(diagramModel:DiagramModel)
		{
			_diagramModel = diagramModel
		}
		
		
		/* The CutCommand makes clones of the currently selected objects when it is first called 
		   On later redo calls, it will use the clones to populate the clipboard and delete the relevant objects on the diagram 
		   On undo calls, it will add the cut objects back to the diagram
		
		*/
		
		override public function execute():void
		{	
			Logger.debug("execute()",this)
			var sdObjectModelsArr:Array = _diagramModel.selectedArray
			
			if(sdObjectModelsArr.length<1) 
			{
				Logger.warn("CutCommand was created when no objects were selected.", this)
			}
			
			clonesArr = []
			for each (var sdObjectModel:SDObjectModel in sdObjectModelsArr)
			{
				
				Logger.debug("adding clone for object with sdID: " + sdObjectModel.sdID,this)
				clonesArr.push(sdObjectModel.clone())
			}
			
			redo()
		}
		
		/* Add the objects back onto the stage as if they were never cut */		
		override public function undo():void
		{						
			Logger.debug("undo() ",this)
			for each (var sdObjectModel:SDObjectModel in clonesArr)
			{				
				Logger.debug("cloned object to add back sdID: " + sdObjectModel.sdID,this)
				var sdObj:SDObjectModel = sdObjectModel.clone()
				Logger.debug("cloned object id: " + sdObj.sdID,this)
				_diagramModel.addSDObjectModel(sdObj)
				Logger.debug("after add clonded object sdID: " + sdObj.sdID, this)
				//_diagramModel.addToSelected(sdObj)			
			}	
		}
		
		/* Cut the selected objects from the stage */		
		override public function redo():void
		{
			
			Clipboard.generalClipboard.clear(); 				
			Clipboard.generalClipboard.setData("com.simplediagrams.sdObjects", clonesArr, false)
			
			for each (var sdObjectModel:SDObjectModel in clonesArr)
			{				
				Logger.debug("deleting object id: " + sdObjectModel.sdID)
				_diagramModel.deleteSDObjectModelByID(sdObjectModel.sdID)
			}	
		}
		
		
	}
}
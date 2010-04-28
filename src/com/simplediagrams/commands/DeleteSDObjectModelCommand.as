package com.simplediagrams.commands
{
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.model.mementos.*;
	
	public class DeleteSDObjectModelCommand extends UndoRedoCommand
	{
		private var _diagramModel:DiagramModel
		private var _memento:SDObjectMemento
		
		public function DeleteSDObjectModelCommand(diagramModel:DiagramModel, sdObjectModelToDelete:SDObjectModel)
		{
			_diagramModel = diagramModel
			_memento = sdObjectModelToDelete.getMemento()
			super();
		}
		
		override public function execute():void
		{	
			redo()
		}
		
		override public function undo():void
		{						
			if (_memento is SDSymbolMemento)
			{
				
			}
			else if (_memento is SDTextAreaMemento)
			{
				
			}
			else if (_memento is SDLineMemento)
			{
				
			}
			else if (_memento is SDPencilDrawingMemento)
			{
				
			}
			else if (_memento is SDImageMemento)
			{
				
			}
		}
		
		override public function redo():void
		{							
			_diagramModel.deleteSDObjectModelByID(_memento.sdID)
		}
		
		
	}
}

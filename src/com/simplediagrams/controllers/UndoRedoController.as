package com.simplediagrams.controllers
{
	import com.simplediagrams.events.UndoRedoEvent;
	import com.simplediagrams.model.UndoRedoManager;
	
	import flash.events.Event;
	
	import org.swizframework.controller.AbstractController;

	public class UndoRedoController extends AbstractController
	{
		
		[Autowire]
		public var undoRedoManager:UndoRedoManager
		
		public function UndoRedoController()
		{
		}
		
		
		[Mediate(event="UndoRedoEvent.UNDO")]
		public function onUndo(event:UndoRedoEvent):void
		{
			if (undoRedoManager.canUndo)
			{
				undoRedoManager.undo()
			}
		}
		
		[Mediate(event="UndoRedoEvent.REDO")]
		public function onRedo(event:UndoRedoEvent):void
		{
			if (undoRedoManager.canRedo)
			{
				undoRedoManager.redo()
			}
		}
		
		[Mediate(event="LoadDiagramEvent.DIAGRAM_LOADED")]
		[Mediate(event="CreateNewDiagramEvent.NEW_DIAGRAM_CREATED")]
		public function onClear(event:Event):void
		{
			undoRedoManager.clear()
		}
		
	}
}
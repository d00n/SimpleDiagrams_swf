package com.simplediagrams.controllers
{
	import com.simplediagrams.commands.TransformCommand;
	import com.simplediagrams.events.MoveOnceEvent;
	import com.simplediagrams.events.ObjectChangedEvent;
	import com.simplediagrams.events.RemoteSharedObjectEvent;
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.model.UndoRedoManager;
	import com.simplediagrams.model.mementos.TransformMemento;
	import com.simplediagrams.util.Logger;
	
	import org.swizframework.controller.AbstractController;
	import org.swizframework.Swiz;

	public class ObjectHandlesController extends AbstractController
	{
		[Autowire]
		public var diagramModel:DiagramModel
		
		[Autowire]
		public var undoRedoManager:UndoRedoManager

		[Autowire]
		public var remoteSharedObjectController:RemoteSharedObjectController

		
		public function ObjectHandlesController()
		{
		}
		
		[Mediate(event="ObjectChangedEvent.OBJECT_MOVED")]
		[Mediate(event="ObjectChangedEvent.OBJECT_RESIZED")]
		[Mediate(event="ObjectChangedEvent.OBJECT_ROTATED")]
		public function onObjectChanged(event:ObjectChangedEvent):void
		{
			Logger.debug("onObjectChange() event: " + event.type,this)
			Logger.debug("onObjectChange() event.relatedObjects.length: " + event.relatedObjects.length,this)
			var transformedObjectsArr:Array = new Array();
			var rsoEvent:RemoteSharedObjectEvent;
			for each (var sdObjectModel:SDObjectModel in event.relatedObjects)
			{
				var from:TransformMemento = sdObjectModel.getStartTransformState()
				var to:TransformMemento = sdObjectModel.getTransformState()
				var o:Object = {sdID:sdObjectModel.sdID, fromState:from, toState:to}
				transformedObjectsArr.push(o);
				
			}
						
			var cmd:TransformCommand = new TransformCommand(diagramModel, transformedObjectsArr)
			undoRedoManager.push(cmd)
				
			//remoteSharedObjectController.dispatchUpdate_ObjectChanged(cmd)			
				
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.OBJECT_CHANGED);	
			Swiz.dispatchEvent(rsoEvent);
		}
		
		
		
		[Mediate(event="ObjectChangedEvent.OBJECT_START_MOVING")]
		[Mediate(event="ObjectChangedEvent.OBJECT_START_RESIZING")]
		public function onObjectChanging(event:ObjectChangedEvent):void			
		{
			Logger.debug("\n\nonObjectChanging()",this)
				
			for each (var sdObjectModel:SDObjectModel in event.relatedObjects)
			{
				Logger.debug("object changing: " + sdObjectModel, this)
				Logger.debug("object x: " + sdObjectModel.x, this)
				Logger.debug("object rotation: " + sdObjectModel.rotation, this)
				sdObjectModel.captureStartState()				
			}
			
		}
		
		[Mediate(event="MoveOnceEvent.MOVE_UP")]
		[Mediate(event="MoveOnceEvent.MOVE_DOWN")]
		[Mediate(event="MoveOnceEvent.MOVE_LEFT")]
		[Mediate(event="MoveOnceEvent.MOVE_RIGHT")]
		public function onMoveOnce(event:MoveOnceEvent):void
		{
			var transformedObjectsArr:Array = new Array()
			for each (var sdObjectModel:SDObjectModel in event.relatedObjects)
			{
				sdObjectModel.captureStartState()
				var from:TransformMemento = sdObjectModel.getStartTransformState()
				var to:TransformMemento = sdObjectModel.getTransformState()
				switch (event.type)
				{
					case MoveOnceEvent.MOVE_UP:
						to.y--
						break
					case MoveOnceEvent.MOVE_DOWN:
						to.y++
						break
					case MoveOnceEvent.MOVE_LEFT:
						to.x--
						break
					case MoveOnceEvent.MOVE_RIGHT:
						to.x++
						break
					default:
						Logger.error("onMoveOnce() unrecognized event type: " + event.type,this)
				
				}
				var o:Object = {sdID:sdObjectModel.sdID, fromState:from, toState:to}
				transformedObjectsArr.push(o)
			}
			
			var cmd:TransformCommand = new TransformCommand(diagramModel, transformedObjectsArr)
			cmd.execute()
			undoRedoManager.push(cmd)
				
			//remoteSharedObjectController.dispatchUpdate_ObjectChanged(cmd)
			var rsoEvent:RemoteSharedObjectEvent = new RemoteSharedObjectEvent(RemoteSharedObjectEvent.OBJECT_CHANGED);	
			Swiz.dispatchEvent(rsoEvent);

		}
		
		
	}
}
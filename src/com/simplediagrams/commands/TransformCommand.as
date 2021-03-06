package com.simplediagrams.commands
{
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.SDObjectModel;
	import com.simplediagrams.model.mementos.TransformMemento;
	import com.simplediagrams.util.Logger
	
	public class TransformCommand extends UndoRedoCommand
	{	
		//each object in _transformedObjectsArr array has form {sdID:(sdID of sdObjectModel), fromState:TransformMemento, toState:TransformMemento}		
		protected var _transformedObjectsArr:Array 		
		protected var _diagramModel:DiagramModel		
		
		public function TransformCommand(diagramModel:DiagramModel, transformedObjectsArr:Array)
		{
			_diagramModel = diagramModel
			_transformedObjectsArr = transformedObjectsArr
			super();
		}

		public function get TransformedObjectsArray () : Array { return _transformedObjectsArr; }

		override public function execute():void
		{
			redo()
		}
		
		override public function redo():void
		{
			Logger.info("redo() TRANSFORM" ,this)
			for each (var obj:Object in _transformedObjectsArr)
			{
				var sdObjectModel:SDObjectModel = _diagramModel.getModelByID(obj.sdID)
				Logger.debug("sdObjectModel.sdID: " + sdObjectModel.sdID, this)
				if (sdObjectModel)
				{
					sdObjectModel.setTransformState(obj.toState)
					Logger.debug("after setting memento sdObjectModel.sdID" + sdObjectModel.sdID, this)
				}
				else
				{
					Logger.warn("Couldn't find model with id: " + obj.sdID + " for redoing transform command",this)
				}
			}	
		}
		
		override public function undo():void
		{
			Logger.debug("undo() _transformedObjectsArr.length: " + _transformedObjectsArr.length,this)
			for each (var obj:Object in _transformedObjectsArr)
			{
				Logger.debug("undo() finding _sd:" + obj.sdID,this)
				var sdObjectModel:SDObjectModel = _diagramModel.getModelByID(obj.sdID)
				if (sdObjectModel)
				{
					sdObjectModel.setTransformState(obj.fromState)
				}
				else
				{
					Logger.warn("Couldn't find model with id: " + obj.sdID + " for undoing transform command",this)
				}
			}			
		}
		
	
		
		
	}
}
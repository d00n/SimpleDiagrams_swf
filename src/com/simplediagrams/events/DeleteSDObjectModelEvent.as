package com.simplediagrams.events
{
	import com.simplediagrams.model.SDObjectModel;
	
	import flash.events.Event;
	
	public class DeleteSDObjectModelEvent extends Event
	{
		public static const DELETE_SELECTED_FROM_MODEL:String = "deleteSelectedSDObjectModelFromDiagramModel" //this is called to delete a component
		public static const DELETE_FROM_MODEL:String = "deleteSDObjectModelFromDiagramModel" //this is called to delete a component
		
		public var sdObjectModel:SDObjectModel
		
		public function DeleteSDObjectModelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
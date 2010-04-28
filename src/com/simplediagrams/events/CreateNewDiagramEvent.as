package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class CreateNewDiagramEvent extends Event
	{
		public static const CREATE_NEW_DIAGRAM:String = "createNewDiagram"
		public static const NEW_DIAGRAM_CREATED:String = "newDiagramCreated"
		
		public function CreateNewDiagramEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
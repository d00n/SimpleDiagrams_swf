package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class SaveDiagramEvent extends Event
	{
		
		public static const SAVE_DIAGRAM:String = "saveDiagramEvent"
		public static const SAVE_DIAGRAM_AS:String = "saveDiagramAsEvent"
		public static const DIAGRAM_SAVED:String = "diagramSavedEvent"
		
		public var nativePath:String 
		public var fileName:String
		
		public function SaveDiagramEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
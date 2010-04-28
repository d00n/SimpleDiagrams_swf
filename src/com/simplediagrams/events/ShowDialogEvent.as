package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class ShowDialogEvent extends Event
	{
		public static const OPEN_DIAGRAM_DIALOG:String = "openDiagramDialog"
		public static const NEW_DIAGRAM_DIALOG:String = "newDiagramDialog"
		
		public function ShowDialogEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
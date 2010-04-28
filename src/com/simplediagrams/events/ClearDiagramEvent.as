package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class ClearDiagramEvent extends Event
	{
		public static const CLEAR_DIAGRAM:String = "clearDiagramEvent"
		
		public function ClearDiagramEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
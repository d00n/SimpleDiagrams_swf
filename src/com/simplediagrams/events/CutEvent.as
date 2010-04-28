package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class CutEvent extends Event
	{
		public static const CUT:String = "cutEvent"
		
		public function CutEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class CopyEvent extends Event
	{
		public static const COPY:String = "copyEvent"
		
		public function CopyEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class TrialEvent extends Event
	{
		
		public static const CONTINUE:String = "continueTrial"
		
		public function TrialEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
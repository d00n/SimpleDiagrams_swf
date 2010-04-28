package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class ClearRecentListEvent extends Event
	{
		public static const CLEAR_RECENT_LIST:String="clearRecentList"
		
		public function ClearRecentListEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
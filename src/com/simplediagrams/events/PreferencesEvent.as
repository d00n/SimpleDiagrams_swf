package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class PreferencesEvent extends Event
	{
		public static const SHOW_PREFERENCES_WINDOW:String = "showPrefWindow"
			
		public function PreferencesEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
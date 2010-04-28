package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class AboutEvent extends Event
	{
		public static const SHOW_ABOUT_WINDOW:String = "showAboutWindow"
		
		public function AboutEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class StyleEvent extends Event
	{
		public static const CHANGE_STYLE:String = "changeStyle"
		public static const STYLE_CHANGED:String = "styleChanged"
		
		public var styleName:String
		public var isLoadedStyle:Boolean = false //flag for this event when set as part of a diagram load sequence
		
		public function StyleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
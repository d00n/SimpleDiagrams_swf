package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class ZoomEvent extends Event
	{
		public static const ZOOM_IN:String = "zoomIn"
		public static const ZOOM_OUT:String = "zoomOut"
		
		public function ZoomEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
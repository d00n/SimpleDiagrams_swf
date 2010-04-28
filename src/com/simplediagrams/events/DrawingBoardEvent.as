package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class DrawingBoardEvent extends Event
	{
		public static const MOUSE_OVER:String = "drawingBoardMouseOver"
		
		public function DrawingBoardEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
package com.simplediagrams.events
{
	import com.simplediagrams.view.SDComponents.SDBase;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ConnectionEvent extends Event
	{
		public static const START_CONNECTION_DRAG:String = "startConnectionDrag"
		public static const FINISH_CONNECTION_DRAG:String = "finishConnectionDrag"
		
		public var startingComponent:SDBase 
		public var endingComponent:SDBase 
		
		public var mouseEvent:MouseEvent 
		
		public function ConnectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
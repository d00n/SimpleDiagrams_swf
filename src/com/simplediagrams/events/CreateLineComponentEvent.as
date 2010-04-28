package com.simplediagrams.events
{
	
	import flash.events.Event;

	public class CreateLineComponentEvent extends Event
	{
	
		public static const CREATE:String = "createLineComponentEvent"
	
		public var initialX:Number
		public var initialY:Number
		
		public var finalX:Number
		public var finalY:Number
		
		public function CreateLineComponentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
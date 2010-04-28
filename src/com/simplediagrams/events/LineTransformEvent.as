package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class LineTransformEvent extends Event
	{		
		public var startX:Number
		public var startY:Number
		public var endX:Number
		public var endY:Number
		public var bendX:Number
		public var bendY:Number
		
		public function LineStyleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
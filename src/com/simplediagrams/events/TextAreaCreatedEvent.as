package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class TextAreaCreatedEvent extends Event
	{
		
		public static const CREATED:String = "textAreaCreated"
		
		public var dropX:Number
		public var dropY:Number
		
		public function TextAreaCreatedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
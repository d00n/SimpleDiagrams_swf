package com.simplediagrams.events
{
	import flash.events.Event;
	import flash.geom.Point;

	public class PencilDrawingEvent extends Event
	{
		
		public static const DRAWING_CREATED:String = "drawingCreated"
		
		public var initialX:Number = 0
		public var initialY:Number = 0
		
		public var path:String = ""
		public var initialPoint:Point
		
		public var width:Number 
		public var height:Number
		
		public var color:Number
		
		public function PencilDrawingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
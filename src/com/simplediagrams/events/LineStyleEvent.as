package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class LineStyleEvent extends Event
	{
		public static const LINE_START_STYLE_CHANGE:String = "lineStartStyleChange"
		public static const LINE_END_STYLE_CHANGE:String = "lineEndStyleChange"
		public static const LINE_WEIGHT_CHANGE:String = "lineWeightChange"
		
		public var lineStyle:int
		public var lineWeight:int
		
		public function LineStyleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
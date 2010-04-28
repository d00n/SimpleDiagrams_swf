package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class MultiSelectEvent extends Event
	{
		
		//These types are used when a user drags a marquee to multiselect
		public static const DRAG_MULTI_SELECTION_MADE:String = "dragmultiSelectionMade"
		public static const DRAG_MULTI_SELECTION_FINISHED:String = "dragMultiSelectionFinished"
			
		//This type is launched by ObjectHandles when a user shift-clicks to add or remove an object
		public static const MULTI_SELECT_CHANGE:String = "multiSelectChange"
		
		public var startX:Number
		public var startY:Number
		public var endX:Number
		public var endY:Number
		public var selectedArr:Array = [] //holds all SDObjects that were within Marquee drawing
		
		public function MultiSelectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
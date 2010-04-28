package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class ObjectChangedEvent extends Event
	{
		
		public static const OBJECT_START_RESIZING:String = "objectStartResizing"
		public static const OBJECT_START_MOVING:String = "objectStartMoving"
			
		public static const OBJECT_MOVING:String = "objectMoving";
		public static const OBJECT_RESIZING:String = "objectResizing";
		public static const OBJECT_ROTATING:String = "objectRotating";
			
		public static const OBJECT_MOVED:String = "objectMoved";
		public static const OBJECT_RESIZED:String = "objectResized";
		public static const OBJECT_ROTATED:String = "objectRotated";
		
		
		
		/**
		 * An array of objects that were moved/resized or rotated.
		 **/
		public var relatedObjects:Array;
		
		public function ObjectChangedEvent(relatedObjects:Array, type:String,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.relatedObjects = relatedObjects;
		}
		
	}
}

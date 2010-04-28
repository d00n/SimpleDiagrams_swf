package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class StoredLibraryLoadEvent extends Event
	{
		public static const LOAD_ERROR:String = "loadError"
		public static const LOAD_COMPLETE:String = "loadComplete"
		
		public var libraryID:int
		public var errorMessage:String 
		
		public function StoredLibraryLoadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
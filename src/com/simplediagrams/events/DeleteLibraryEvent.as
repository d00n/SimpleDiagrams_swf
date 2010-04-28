package com.simplediagrams.events
{
	import com.simplediagrams.model.libraries.ILibrary;
	
	import flash.events.Event;
	
	public class DeleteLibraryEvent extends Event
	{
		public static const DELETE_LIBRARY:String= "deleteLibrary"
		
		public var library:ILibrary
			
		public function DeleteLibraryEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
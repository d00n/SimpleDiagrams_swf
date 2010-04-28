package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class PropertiesEvent extends Event
	{
		public static const EDIT_PROPERTIES:String = "editPropertiesEvent"
		public static const PROPERTIES_EDITED:String = "propertiesEdited"
		
		public function PropertiesEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
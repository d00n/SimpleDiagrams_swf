package com.simplediagrams.events
{
	import com.simplediagrams.view.SDComponents.ISDComponent;
	
	import flash.events.Event;

	public class DeleteSDComponentEvent extends Event
	{		
		public static const DELETE_FROM_DIAGRAM:String = "deleteFromDiagram" //this is called after the component is delete to remove it from the diagram
		
		public var sdComponent:ISDComponent
		
		public function DeleteSDComponentEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
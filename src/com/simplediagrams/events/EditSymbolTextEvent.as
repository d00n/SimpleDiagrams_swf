package com.simplediagrams.events
{
	import com.simplediagrams.model.SDSymbolModel
	import flash.events.Event;
	
	public class EditSymbolTextEvent extends Event
	{
		public static const EDIT_SYMBOL_TEXT:String = "editSymbolText"
			
		public var sdSymbolModel:SDSymbolModel
		
		public function EditSymbolTextEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
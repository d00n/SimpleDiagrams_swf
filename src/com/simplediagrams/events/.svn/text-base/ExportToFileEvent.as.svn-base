package com.simplediagrams.events
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.validators.StringValidator;
	
	import spark.components.Scroller;

	public class ExportToFileEvent extends ExportDiagramUserRequestEvent
	{
		
		public static const EXPORT_DIAGRAM_USER_REQUEST:String = "exportDiagramToFileUserRequestEvent"  		//issued by menu or other control
		public static const EXPORT_DIAGRAM:String = "exportDiagramToFileEvent"									//issued by view after it has attached a reference to the view on the event
		
		public function ExportToFileEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
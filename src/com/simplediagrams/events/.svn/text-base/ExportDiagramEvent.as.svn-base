package com.simplediagrams.events
{
	import flash.events.Event;
	
	import mx.core.UIComponent;
	import mx.validators.StringValidator;
	
	import spark.components.Scroller;
	
	public class ExportDiagramEvent extends ExportDiagramUserRequestEvent
	{
		
		public static const EXPORT_TO_BASECAMP:String = "exportDiagramToBaseCamp"
		public static const EXPORT_TO_FLICKR:String = "exportToFlickr"
		public static const EXPORT_TO_FILE:String = "exportToFile"
			
		public static const FORMAT_PNG:String = "pngFormat"
		public static const FORMAT_JPG:String = "jpgFormat"
		public static const FORMAT_PDF:String = "pdfFormat"				
			
		public var view:UIComponent				//this is a ref to the view we want to export as image
		public var format:String 				//types are const's described above
		public var scroller:Scroller 			//keep this ref so controller can hide it			
		
		public function ExportDiagramEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
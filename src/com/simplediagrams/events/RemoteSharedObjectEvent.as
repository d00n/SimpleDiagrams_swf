package com.simplediagrams.events
{
	import com.simplediagrams.model.SDImageModel;
	
	import flash.events.Event;
	import flash.utils.ByteArray;

	
	public class RemoteSharedObjectEvent extends Event
	{
		
		public static const CHANGE_ALL_SHAPES_TO_DEFAULT_COLOR:String = "rso_changeAllShapesToDefaultColor";
		public static const RESET:String = "rso_reset";
		public static const STOP:String = "rso_stop";
		public static const START:String = "rso_start";
		public static const LOAD_IMAGE:String = "rso_loadImage";
		public static const CHANGE_COLOR:String = "rso_changeColor";
		public static const DISPATCH_TEXT_AREA_CHANGE:String = "rso_dispatchTextAreaChange";
		
		private var _imageData:ByteArray
		public static const STYLE_PHOTO:String = "photoStyle";
		public var sdImageModel:SDImageModel;
		public var text:String;
		public var color:Number;
		public var sdID:Number;

		public function RemoteSharedObjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public function set imageData(v:ByteArray):void
		{
			_imageData = v;
		}
		public function get imageData():ByteArray
		{
			return _imageData;
		}
	}
}
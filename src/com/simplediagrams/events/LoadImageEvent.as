package com.simplediagrams.events
{
	import com.simplediagrams.model.SDImageModel;
	
	import flash.events.Event;
//	import flash.filesystem.File;

	public class LoadImageEvent extends Event
	{
		public static const BROWSE_FOR_IMAGE:String = "browseForImage"
		public static const LOAD_IMAGE_FILE:String = "loadImageFile"
		public static const IMAGE_LOADED:String = "imageLoaded"
		public static const ADD_IMAGE_FROM_MENU:String = "addImageFromMenu"
		
//		public var file:File
		public var dropX:Number
		public var dropY:Number
		
		public var model:SDImageModel
		
		public function LoadImageEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
//			this.file = file
			super(type, bubbles, cancelable);
		}
	}
}
package com.simplediagrams.business
{
	import com.adobe.example.packaging.Unpackager;
	import com.simplediagrams.util.Logger;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
//	import flash.filesystem.File;
	import flash.net.URLRequest;

	public class LibraryPluginUnpacker extends EventDispatcher
	{
		
		public static const UNPACK_OK:String = "unpackOK"
		public static const UNPACK_FAILED:String = "unpackFailed"
		
//		protected var _unpackager:Unpackager
//		protected var _file:File
//		protected var _destinationDirectory:File
//		
//		public var success:Boolean = false
//			
//		public function LibraryPluginUnpacker()
//		{
//		}
//		
//		public function get file():File
//		{
//			return _file
//		}
//		
//		public function get destinationDirectory():File
//		{
//			return _destinationDirectory
//		}
		
//		public function unpack(file:File, destinationDirectory:File):void
//		{	
//			_file = file
//			_destinationDirectory = destinationDirectory
//			if (_file.extension=="zip")
//			{			
//				try
//				{
//					Logger.debug("Unpacking .zip", this)
//					Logger.debug("desintation dir: " + destinationDirectory.nativePath, this)
//					if (destinationDirectory.exists)
//					{
//						destinationDirectory.deleteDirectory(true)
//					}
//					destinationDirectory.createDirectory()
//					_unpackager = new Unpackager()	
//					_unpackager.addEventListener(Event.COMPLETE, onUnpackingComplete)
//					_unpackager.addEventListener(ErrorEvent.ERROR, onUnpackingError)
//					var urlRequest:URLRequest = new URLRequest(_file.url)
//					_unpackager.unpack(urlRequest, destinationDirectory)
//				}
//				catch(err:Error)
//				{
//					Logger.error("Couldn't unpack the .zip library : " + _file.name + " error :" + err, this)
//					dispatchEvent(new Event(UNPACK_FAILED, true))
//				}
//			}
//		}
			
		protected function onUnpackingComplete(event:Event):void
		{
//			success = true
//			removeListeners()
//			dispatchEvent(new Event(UNPACK_OK, true))			
		}		
		protected function onUnpackingError(event:ErrorEvent):void
		{
			removeListeners()
			dispatchEvent(new Event(UNPACK_FAILED, true))			
		}
		
		protected function removeListeners():void
		{			
//			_unpackager.removeEventListener(Event.COMPLETE, onUnpackingComplete)
//			_unpackager.removeEventListener(ErrorEvent.ERROR, onUnpackingError)
//			_unpackager = null
		}
		
	}
}
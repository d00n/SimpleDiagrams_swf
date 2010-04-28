package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class DownloadLibraryEvent extends Event
	{
		public static const DOWNLOAD_AVAILABLE_LIBARIES_LIST:String = "downloadAvailableLibrariesList"
		public static const DOWNLOAD_LIBRARIES:String = "downloadLibraries"
			
		public var libraryIDsToDownloadArr:Array
		
		public function DownloadLibraryEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
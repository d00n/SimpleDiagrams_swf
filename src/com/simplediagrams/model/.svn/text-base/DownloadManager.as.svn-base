package com.simplediagrams.model
{
	
	import com.simplediagrams.events.DownloadLibraryEvent;
	import com.simplediagrams.util.Logger;
	
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import mx.collections.ArrayCollection
	
	[Bindable]	
	public class DownloadManager extends EventDispatcher
	{

		public static const DOWNLOADING_LIBRARIES_LIST:String = "downloadingLibraryList"
		public static const SELECT_LIBRARIES_TO_DOWNLOAD:String = "selectLibrariesToDownload"
		public static const DONWLOADING_SELECTED_LIBRARIES:String = "downloadingSelectedLibraries"
		public static const LIBRARIES_DOWNLOADED:String = "librariesDownloaded"
		public static const DOWNLOAD_LIBRARIES_LIST_ERROR:String = "downloadLibrariesListError"
		public static const DOWNLOAD_LIBRARIES_ERROR:String = "downloadLibrariesError";
				
		[Autowire(bean="registrationManager")]
		public var registrationManager:RegistrationManager;
		
		[Autowire(bean="downloadManager")]
		public var downloadManager:DownloadManager;
		
		public var viewing:String = DOWNLOADING_LIBRARIES_LIST
		
		public var downloadableLibrariesAC:ArrayCollection
		
		public function DownloadManager()
		{
		}
	
	
	
	
	}
}
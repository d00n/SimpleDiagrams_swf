package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class FlickrEvent extends Event
	{
		public static const CANCEL_UPLOAD:String = "flickrCancelUpload"
		public static const AUTHORIZATION_COMPLETE:String = "flickrAuthorizationComplete"
		public static const CLEAR_LOGIN_CREDENTIALS:String = "clearFlickrLoginCredentials"
		public static const SHOW_AUTHORIZE_WEBPAGE:String = "showAuthorizeWebpage"
		public static const EXPORT_DIAGRAM:String ="exportDiagramToFlickr"
		
		public function FlickrEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
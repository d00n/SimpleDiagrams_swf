package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class BasecampEvent extends Event
	{
		public static const GET_PROJECTS:String = "getBasecampProjects"
		public static const REFRESH_PROJECTS:String = "refreshBasecampProjects"
		public static const CANCEL_UPLOAD:String = "cancelUpload"
		public static const CLEAR_LOGIN_CREDENTIALS:String = "clearBasecampLoginCredentials"
			
		public static const SHOW_CHANGE_NOTIFY_WINDOW:String = "showChangeNotifyWindow"	
		public static const REFRESH_PEOPLE:String = "refreshPeopleList"			
		
		public function BasecampEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}
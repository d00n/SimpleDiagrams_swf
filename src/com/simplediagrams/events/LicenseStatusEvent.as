package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class LicenseStatusEvent extends Event
	{
		
		public static const GET_STATUS:String = "getStatus"
		public static const LICENSE_STATUS_RESPONSE:String = "licenseStatusResponse"
		
		public var status:int
		
		public function LicenseStatusEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
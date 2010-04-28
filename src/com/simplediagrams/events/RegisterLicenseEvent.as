package com.simplediagrams.events
{
	import flash.events.Event;
	
	public class RegisterLicenseEvent extends Event
	{
		
		public static const VALIDATE_LICENSE:String = "validateLicense"
		public static const VALIDATE_LICENSE_RESULT:String = "validateLicenseResult"
		public static const LICENSE_VALIDATED:String = "licenseValidated"
			
		public static const ERROR_HTTP:String="httpError"
		public static const ERROR_SECURITY:String="securityError"
		public static const ERROR_IO:String="ioError"
						
		
		public var email:String
		public var licenseKey:String			
		public var status:Number
		
		public function RegisterLicenseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}
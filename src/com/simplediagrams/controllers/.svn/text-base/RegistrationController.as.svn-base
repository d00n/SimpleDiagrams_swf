package com.simplediagrams.controllers
{
	import com.simplediagrams.events.RegisterLicenseEvent;
	import com.simplediagrams.events.RegistrationViewEvent;
	import com.simplediagrams.model.ApplicationModel;
	import com.simplediagrams.model.LibraryManager;
	import com.simplediagrams.model.RegistrationManager;
	import com.simplediagrams.util.Logger;
	
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import org.swizframework.Swiz;
	import org.swizframework.controller.AbstractController;

	public class RegistrationController extends AbstractController
	{
		
		[Autowire(bean="applicationModel")]
		public var appModel:ApplicationModel;
		
		[Autowire(bean="registrationManager")]
		public var registrationManager:RegistrationManager;		
				
		
		public function RegistrationController()
		{
		}
		
		
		[Mediate(event="RegistrationViewEvent.USER_AGREED_TO_LICENSE")]
		public function userAgreedToLicense(event:RegistrationViewEvent):void
		{
			appModel.userAgreedToEULA()
			registrationManager.viewing = RegistrationManager.VIEW_FREE_MODE						
		}
				
		[Mediate(event="RegisterLicenseEvent.VALIDATE_LICENSE")]
		public function validateLicense(event:RegisterLicenseEvent):void
		{
			registrationManager.registerViewing = RegistrationManager.REGISTER_VIEW_WAITING			
			registrationManager.tryingToValidateWithKey = event.licenseKey				
			var urlRequest:URLRequest = new URLRequest("http://simplediagrams.heroku.com/registrations/validate")
				
			// For testing:
			//var urlRequest:URLRequest = new URLRequest("http://localhost:3000/registrations/validate")
				
			urlRequest.method = URLRequestMethod.POST
			var variables:URLVariables = new URLVariables();
			variables.email = event.email
			variables.key = event.licenseKey
			urlRequest.data = variables;
			
			executeURLRequest(urlRequest, resultHandler, faultHandler,  progressHandler, httpStatusHandler);
			
		}
		
		protected function resultHandler(e:Event):void
		{
			var result:String = e.currentTarget.data;
			Logger.debug("result: " + result, this)
			var status:int
			try
			{
				var resultXML:XML = XML(result)
				status = resultXML.@id
				if (status==RegistrationManager.STATUS_REGISTRATION_OK)
				{
					var unlockHash:String = resultXML.@unlock
				}
			}
			catch(err:Error)
			{
				Logger.error("resultHandler: error converting response: " + resultXML + " to XML. Error: " +err, this)
				status = RegistrationManager.STATUS_ERROR_RESPONSE_UNRECOGNIZED
			}
			
			
			switch(status)
			{							
				case RegistrationManager.STATUS_ERROR_EMAIL_AND_KEY_COMBINATION_NOT_FOUND:
					registrationManager.viewing = RegistrationManager.VIEW_REGISTER
					registrationManager.registerViewing = RegistrationManager.REGISTER_VIEW_ERROR
					registrationManager.errorMsg = "The entered email and/or license key was not found on the security server. Please try again or contact us for help."
					break;
				
				case RegistrationManager.STATUS_ERROR_MAXCOUNT:
					registrationManager.viewing = RegistrationManager.VIEW_REGISTER
					registrationManager.registerViewing = RegistrationManager.REGISTER_VIEW_ERROR 
					registrationManager.errorMsg ="The entered key was already used for the alotted number of registrations. Please enter a key that has not been used yet or contact us for help."
					break;
				
				case RegistrationManager.STATUS_ERROR_KEY_REVOKED:
					registrationManager.viewing = RegistrationManager.VIEW_REGISTER
					registrationManager.registerViewing = RegistrationManager.REGISTER_VIEW_ERROR
					registrationManager.errorMsg = "This key has been revoked, probably because it was used too many times. Please contact us for help."
					break;
											
				case RegistrationManager.STATUS_REGISTRATION_OK:	
					
					//TODO: make sure hash is correct
					Logger.debug("registration OK. unlock hash: " + unlockHash, this)
					var licenseKey:String = registrationManager.tryingToValidateWithKey
					if (licenseKey=="")
					{
						Logger.error("licenseKey was an empty string when it should have had a license key.",this)
						registrationManager.viewing = RegistrationManager.VIEW_REGISTER
						registrationManager.registerViewing = RegistrationManager.REGISTER_VIEW_ERROR 
						registrationManager.errorMsg ="Unfortunately SimpleDiagrams is experiencing an error when trying to validate your key. Please contact support@simplediagrams.com and we'll help you out ASAP."
						return							
					}
					registrationManager.registerApplication(licenseKey)	
					registrationManager.viewing = RegistrationManager.VIEW_REGISTRATON_SUCCESS
					Swiz.dispatchEvent(new RegisterLicenseEvent(RegisterLicenseEvent.LICENSE_VALIDATED, true))
					break
				
				default:
					Logger.error("resultHandler() unrecognized event: " + e, this)
					registrationManager.viewing = RegistrationManager.VIEW_REGISTER
					registrationManager.registerViewing = RegistrationManager.REGISTER_VIEW_ERROR
					registrationManager.errorMsg = "There was an error contacting the license server. Please try again or contact us for help."
			}
			
							
		}
		
		protected function faultHandler(e:Event):void
		{
			Logger.debug("faultHandler e : " + e, this)
			// a fault event can be IOErrorEvent or SecurityErrorEvent
			
			if(e is IOErrorEvent)
			{
				Logger.debug("faultHandler() IOError: " + IOErrorEvent(e).toString(),this)
			}
			else if (e is SecurityErrorEvent)
			{				
				Logger.debug("faultHandler() Security error: " + e,this)
			}
			else
			{
				Logger.debug("faultHandler() error: " + e,this)
			}
			
			registrationManager.viewing = RegistrationManager.VIEW_SERVER_UNAVALABLE
		}
		
		protected function progressHandler(e:ProgressEvent):void
		{
			Logger.debug("progressHandler(): e: "+ e, this)
		}
		
		protected function httpStatusHandler(e:HTTPStatusEvent):void
		{
			Logger.debug("httpStatusHandler(): e: "+ e, this)
		}

		      
        
        [Mediate(event="RegistrationViewEvent.USE_IN_FULL_MODE")]
        public function startUsingSD(event:RegistrationViewEvent):void
        {
			//TODO : any kind of extra functionality that gets included with premium version can be activated here
			Logger.debug("startUsingSD",this)			
        	appModel.viewing = ApplicationModel.VIEW_STARTUP  
        	appModel.menuEnabled = true  	
        }
		
		
		[Mediate(event="RegistrationViewEvent.USE_IN_FREE_MODE")]
		public function startFreeVersion(event:RegistrationViewEvent):void
		{
			appModel.startNagWindow()
			appModel.viewing = ApplicationModel.VIEW_STARTUP  
			appModel.menuEnabled = true  	
		}
		
		[Mediate(event="RegistrationViewEvent.TRY_REGISTERING_AGAIN")]
		public function tryRegisteringAgain(event:RegistrationViewEvent):void
		{
			Logger.debug("trying again...",this)
			registrationManager.viewing = RegistrationManager.VIEW_REGISTER
			registrationManager.registerViewing = RegistrationManager.REGISTER_VIEW_NORMAL
		}
		
        
				
		
		
	}
}
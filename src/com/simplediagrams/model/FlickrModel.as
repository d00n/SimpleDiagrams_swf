package com.simplediagrams.model
{
	
	
	import com.adobe.webapis.flickr.Permission;
	
//	import flash.data.EncryptedLocalStore;
	import flash.events.EventDispatcher;
//	import flash.filesystem.*;
	import flash.utils.ByteArray;

	
	[Bindable]
	public class FlickrModel extends EventDispatcher
	{
				
		public var saveLocally:Boolean = false
		
		public static const FLICKR_API_KEY:String = "1f8c8353f5f02fe50998b1a7d9fcf720";
		public static const FLICKR_API_SECRET:String = "37a56463307acc0b";		
		
		
		public static const FLICKR_CONTENT_TYPE_DEFAULT:int = 0;		
		public static const FLICKR_CONTENT_TYPE_PHOTO:int = 1;		
		public static const FLICKR_CONTENT_TYPE_SCREENSHOT:int = 2;		
		public static const FLICKR_CONTENT_TYPE_OTHER:int = 3;

		
		public static const FLICKR_SAFETY_LEVEL_DEFAULT:int = 0;
		public static const FLICKR_SAFETY_LEVEL_SAFE:uint =1
		public static const FLICKR_SAFETY_LEVEL_MODERATE:uint =2
		public static const FLICKR_SAFETY_LEVEL_RESTRICTED:uint =3
		
		public var authToken:String =""
		public var username:String ="" 
		public var frob:String ="" 
		public var permission:String =""
		
		public var isAuthorized:Boolean = false
		
		//values for each image sent
		public var title:String
		public var description:String
		public var tags:String
		public var hidden:Boolean = false
		public var isPublic:Boolean = true
		public var isFamily:Boolean = true
		public var isFriend:Boolean = true
		public var safetyLevel:Number = FLICKR_SAFETY_LEVEL_DEFAULT
		public var contentType:uint=3 //other
		
			
		public var isDirty:Boolean = false
		
		public function FlickrModel()
		{
			//upon creation, see if the user has saved basecamp credentials locally
			loadFromEncryptedStore()
			
		}
							
		
		public function loadFromEncryptedStore():void
		{
			
//			var flickrUsernameBA:ByteArray = EncryptedLocalStore.getItem("flickrUsername")
//			if (flickrUsernameBA) username = flickrUsernameBA.readUTFBytes(flickrUsernameBA.length)
//				
//			var flickrFrobBA:ByteArray = EncryptedLocalStore.getItem("flickrFrob")
//			if (flickrFrobBA) frob = flickrFrobBA.readUTFBytes(flickrFrobBA.length)
			
		}
		
		public function saveToEncryptedStore():void
		{			
//			var ba:ByteArray = new ByteArray()
//			ba.writeUTFBytes(username)
//			EncryptedLocalStore.setItem("flickrUsername", ba )	
//				
//			ba = new ByteArray()
//			ba.writeUTFBytes(frob)
//			EncryptedLocalStore.setItem("flickrFrob", ba )
		}
		
		public function clearFromEncryptedStore():void
		{
//			EncryptedLocalStore.removeItem("flickrAccountName")
		}
		
		
	}
}
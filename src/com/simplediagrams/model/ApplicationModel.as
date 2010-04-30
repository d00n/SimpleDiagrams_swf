package com.simplediagrams.model
{
	import com.simplediagrams.util.Logger;
	
//	import flash.data.EncryptedLocalStore;
//	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
//	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.CloseEvent;
		
	[Bindable]
	public class ApplicationModel extends EventDispatcher
	{
		
		public static const VIEW_REGISTRATION:String = "registrationView"
		public static const VIEW_STARTUP:String = "startupView"
		public static const VIEW_DIAGRAM:String = "diagramView";
						
		public static var logFileDir:String = "logs"
		public static var logFileName:String = "application-log.txt"
			
		//public var dbPath:String = "db/simplediagram.sqlite"
				
		public var loggingOn:Boolean = false	
				
		public var menuEnabled:Boolean = true		
		public var version:String = ""		
		public var txtStatus:String = "" //status messages for startup dialog
		public var app:SimpleDiagrams = FlexGlobals.topLevelApplication as SimpleDiagrams
						
//		public var defaultFileDirectory:File
		
		// In AIR mode, default to VIEW_STARTUP
		//protected var _viewing:String = VIEW_STARTUP
			
		// In swf mode, start with a new board
		protected var _viewing:String = VIEW_DIAGRAM
		
		protected var nagWindowTimer:Timer
		protected var nagAlertOpen:Boolean = false
		
		public function ApplicationModel()
		{
//			defaultFileDirectory = File.userDirectory.resolvePath("SimpleDiagrams")
//						
//			if (!defaultFileDirectory.exists)
//			{
//				defaultFileDirectory.createDirectory()
//			}			
			
			nagWindowTimer = new Timer(1000 * 60 * 5) 			
			nagWindowTimer.addEventListener(TimerEvent.TIMER, onNagWindowTimer)
				
			version = getAppVersion()
		}
		
		protected function getAppVersion():String
		{
		
//			// Get the Application Descriptor File
//			var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
//				
//			// Define the Namespace (there is only one by default in the application descriptor file)
//			var air:Namespace = appXML.namespaceDeclarations()[0];
//			
//			// Use E4X To Extract the Needed Information
//			//this.airApplicationID = appXML.air::id;
//			return appXML.air::version;
//			//this.airApplicationName = appXML.air::name;
			
			return "Not an air app";
		
		}
				
		public function get viewing():String
		{
			return _viewing
		}
		
		public function set viewing(v:String):void
		{
			_viewing = v
		}
		
		public function onNagWindowTimer(event:TimerEvent):void
		{		
			//show nag window
			Logger.debug("nagAlert: " + nagAlertOpen.toString(), this)
			if (!nagAlertOpen)
			{
				nagAlertOpen = true
				var msg:String = "You're using the Free Version of SimpleDiagrams. Why not upgrade to the Full Version today? Visit simplediagrams.com to buy a license and get rid of this silly reminder."
				Alert.show(msg, "Upgrade Today!", 4, FlexGlobals.topLevelApplication as Sprite, onCloseNag)
			}
			
		}
		
		public function onCloseNag(event:CloseEvent):void
		{
			nagAlertOpen = false
		}
		
		public function startNagWindow():void
		{
			Logger.debug("staring nag window")
			nagWindowTimer.reset()	
			nagWindowTimer.start()	
		}
		
		public function stopNagWindow():void
		{
			nagWindowTimer.stop()
		}
		
		public function userAgreedToEULA():void
		{
//			var ba:ByteArray = new ByteArray()
//			ba.writeUTFBytes("true")
//			EncryptedLocalStore.setItem("userAgreedToEULA", ba )
		}
		
		public function didUserAgreeToEULA():Boolean
		{
			return true;
//			var agreedBA:ByteArray = EncryptedLocalStore.getItem("userAgreedToEULA")
//			return (agreedBA && agreedBA.readUTFBytes(agreedBA.length) == "true")
		}
		
		
	}
}
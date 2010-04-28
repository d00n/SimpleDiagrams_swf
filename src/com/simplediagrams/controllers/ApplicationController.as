package com.simplediagrams.controllers
{
	  
	import com.simplediagrams.business.LibraryPluginsDelegate;
	import com.simplediagrams.business.SettingsManager;
	import com.simplediagrams.events.ApplicationEvent;
	import com.simplediagrams.events.CreateNewDiagramEvent;
	import com.simplediagrams.events.LoadDiagramEvent;
	import com.simplediagrams.model.ApplicationModel;
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.DiagramStyleManager;
	import com.simplediagrams.model.LibraryManager;
	import com.simplediagrams.model.RegistrationManager;
	import com.simplediagrams.model.SettingsModel;
	import com.simplediagrams.util.AboutInfo;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.AboutWindow;
	import com.simplediagrams.view.dialogs.LoadingLibraryPluginsDialog;
	import com.simplediagrams.view.dialogs.VerifyQuitDialog;
	
	import flash.events.Event;
//	import flash.filesystem.*;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.events.DynamicEvent;
	
	import org.swizframework.controller.AbstractController;

	public class ApplicationController extends AbstractController 
	{       
		
		[Autowire(bean="applicationModel")]
		public var appModel:ApplicationModel;
		
		[Autowire(bean="registrationManager")]
		public var registrationManager:RegistrationManager;
		
		[Autowire(bean="settingsManager")]
		public var settingsManager:SettingsManager
		
		[Autowire(bean="settingsModel")]
		public var settingsModel:SettingsModel
		
		[Autowire(bean="diagramModel")]
		public var diagramModel:DiagramModel;
				
		[Autowire(bean="libraryManager")]
		public var libraryManager:LibraryManager;
		
		[Autowire(bean="diagramStyleManager")]
		public var diagramStyleManager:DiagramStyleManager
		
		[Autowire(bean="dialogsController")]
		public var dialogsController:DialogsController;
						
		/*
		[Autowire(bean="dbManager")]
		public var db:DBManager;
		*/
	
		
		protected var _verifyQuitDialog:VerifyQuitDialog
		protected var _loadLibraryPluginsDialog:LoadingLibraryPluginsDialog
		protected var _libraryPluginsDelegate:LibraryPluginsDelegate
		protected var _aboutWindow:AboutWindow
		
				   
		public function ApplicationController() 
		{				
			Logger.debug("ApplicationController created.", this)
			
			//add close listener to intercept application close event
//			FlexGlobals.topLevelApplication.addEventListener(Event.CLOSING, onWindowClose, false,0,true);
			
		}
		
		[Mediate(event="CreateNewDiagramEvent.CREATE_NEW_DIAGRAM")]
		public function createNewDiagram(event:CreateNewDiagramEvent):void
		{
			appModel.viewing = ApplicationModel.VIEW_DIAGRAM	
		}
		
		[Mediate(event="LoadDiagramEvent.DIAGRAM_LOADED")]
		public function diagramLoaded(event:LoadDiagramEvent):void
		{	
			Logger.debug("diagramLoaded() ",this)
			appModel.viewing = ApplicationModel.VIEW_DIAGRAM	
		}
		
		[Mediate(event="ApplicationEvent.INIT_APP")]
		public function initApp(event:ApplicationEvent):void
		{	
			Logger.debug("initApp()", this)
			
			//UNCOMMENT THE FOLLOWING ONCE THE APPLICATIONUPDATERUI PROBLEM HAS BEEN FIXED BY ADOBE
			/*
			//Check for updates
			var appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI()
			appUpdater.configurationFile = new File("app:/updateConfig.xml"); 
			appUpdater.initialize();	
			*/
			
			Logger.debug("isLicensed(): " + registrationManager.isLicensed.toString())	
				
			//UNCOMMENT FOR TESTING
			//registrationManager.deleteLicense()
			//EncryptedLocalStore.removeItem("userAgreedToEULA")
				
			//CHECK AGREED TO EULA
				
			var agreedToEULA:Boolean 
			try
			{
				agreedToEULA = appModel.didUserAgreeToEULA()
			}
			catch(err:Error)
			{
				Logger.error("Couldn't read 'agreedToEULA' string from model", this)
				agreedToEULA = false
			}
			
			if (agreedToEULA==false)
			{
				appModel.menuEnabled = false 
				appModel.viewing=ApplicationModel.VIEW_REGISTRATION	
				registrationManager.viewing = RegistrationManager.VIEW_EULA
				return
			}
														
			//load in settings
			settingsManager.loadSettings()
			
			//setup log
			try
			{				
				initLogFile()
			}
			catch(error:Error)
			{
				Logger.error("Couldn't init log. Error: " + error, this)
			}
			
			//CHECK LICENSE			
			Logger.debug("isLicensed: " + registrationManager.isLicensed,this)
			if (registrationManager.isLicensed)
			{	
				//show dialog that we're loading stored libraries
				_loadLibraryPluginsDialog = dialogsController.showLoadLibraryPluginsDialog()
				_loadLibraryPluginsDialog.addEventListener(Event.CANCEL, onLoadLibraryPluginsCancel)
				
				Logger.debug("LOADING LIBRARY PLUG-INS...", this)
				//load library plug-ins
				try
				{
					_libraryPluginsDelegate = new LibraryPluginsDelegate()
					_libraryPluginsDelegate.addEventListener(LibraryPluginsDelegate.LOADING_FINISHED, onLoadingLibraryPluginsFinished)
					_libraryPluginsDelegate.addEventListener(LibraryPluginsDelegate.LOADING_FAILED, onLoadingLibraryPluginsFailed)
					_libraryPluginsDelegate.loadLibraries(libraryManager)
				}
				catch(err:Error)
				{
					Logger.error("Error when loading library plug-ins. Error: " + err, this)	
						
					var msg:String = "An error occurred when loading library plug-ins. One of the library plug-ins may be corrupt. Please delete the library plug-ins and reload them to fix this problem. "
					Alert.show(msg, "Library Load Error")	
				}	
				
			}
			else
			{
				Logger.debug("showing view registration...",this)
				appModel.menuEnabled = false //will be turned on when user clicks continue
				appModel.viewing=ApplicationModel.VIEW_REGISTRATION
				libraryManager.hidePremiumLibraries()
			}			
			
			Logger.debug("settings stylees to:" + settingsModel.defaultDiagramStyle,this)
			//set initial styles -- this should be loaded from a settings folder later
			diagramStyleManager.changeStyle(settingsModel.defaultDiagramStyle)	
							
								
		}
		
		protected function onLoadingLibraryPluginsFinished(event:Event):void
		{	
			if (_libraryPluginsDelegate.errorsEncountered)
			{
				var msg:String = "An error occurred when loading library plug-ins. One of the library plug-ins may be corrupt. Please delete the library plug-ins and reload them to fix this problem. "
					
				Alert.show(msg, "Library Load Error")
			}			
			dialogsController.removeDialog(_loadLibraryPluginsDialog)
			_loadLibraryPluginsDialog = null
			appModel.viewing = ApplicationModel.VIEW_STARTUP			
		}
		
		protected function onLoadingLibraryPluginsFailed(event:Event):void
		{	
			Alert.show("An error occurred when loading library plug-ins. Some library plug-ins may not have loaded correctly. Please see log for details.", "Library Load Error")			
			dialogsController.removeDialog(_loadLibraryPluginsDialog)
			_loadLibraryPluginsDialog = null
			appModel.viewing = ApplicationModel.VIEW_STARTUP			
		}
		
		protected function onLoadLibraryPluginsCancel(event:Event):void
		{
			_loadLibraryPluginsDialog.removeEventListener(Event.CANCEL, onLoadLibraryPluginsCancel)
			dialogsController.removeDialog(_loadLibraryPluginsDialog)			
			_loadLibraryPluginsDialog = null
			_libraryPluginsDelegate.cancelLoad()
			appModel.viewing = ApplicationModel.VIEW_STARTUP	
		}
		
		
		public function onWindowClose(event:Event):void
		{
			Logger.debug("onWindowClose()",this)
			event.preventDefault();
			quitApp(null)
		}
		
		[Mediate(event="ApplicationEvent.QUIT")]
		public function quitApp(event:ApplicationEvent):void
		{
			Logger.debug("quitApp()",this)
			if (diagramModel.isDirty)
			{
				_verifyQuitDialog = dialogsController.showVerifyQuitDialog()
				_verifyQuitDialog.addEventListener(VerifyQuitDialog.QUIT, onQuit)
				_verifyQuitDialog.addEventListener(Event.CANCEL, onCancelSaveBeforeQuit)
			}
			else
			{			
				onQuit(null)
			}
			
		}
		
		
		public function onCancelSaveBeforeQuit(event:Event):void
		{			
			dialogsController.removeDialog(_verifyQuitDialog)
			
			_verifyQuitDialog.removeEventListener(VerifyQuitDialog.QUIT, onQuit)
			_verifyQuitDialog.removeEventListener(Event.CANCEL, onCancelSaveBeforeQuit)
			_verifyQuitDialog = null
			//and then let user continue working...
		}	
		
		public function onQuit(event:Event):void
		{
			settingsManager.saveSettings()
			FlexGlobals.topLevelApplication.exit()
		}
		
	
				
		
		protected function initLogFile():void
		{
//			Logger.debug("initLogFile()", this)
//			
//			//make sure directory exists
//			var logFileDir:File = File.applicationStorageDirectory.resolvePath(ApplicationModel.logFileDir)
//			if (!logFileDir.exists)
//			{
//				try
//				{
//					logFileDir.createDirectory()
//				}
//				catch(error:Error)
//				{
//					Logger.error("Couldn't create log file directory: " + logFileDir.nativePath,this)
//				}
//			}
//				
//			//Clear out any old files							
//			var logFile:File = logFileDir.resolvePath(ApplicationModel.logFileName)
//			if (logFile.exists)
//			{
//				logFile.deleteFile()
//			}
//			
//			Logger.info("SimpleDiagrams version: " + AboutInfo.applicationVersion, this)
//			Logger.info("Flash player version: " + AboutInfo.flashPlayerVersion, this)
//			Logger.info("Writing log file to: " + File.applicationStorageDirectory.resolvePath(ApplicationModel.logFileDir).nativePath, this)
//				
				
		}       
					 
		protected function initLibrary():void
        {
			Logger.debug("initLibrary()", this)
        	libraryManager.loadInitialData()
        }
         
         
      	
		
                
        /*        
        protected function initDB():void
        {
        	
			Logger.debug("initDB()", this)
			//set database according to settings
			if (db.isConnected)
			{
				db.close()
			}
			
			Logger.debug("setting db location to : " + appModel.dbPath , this)
			db.dbLocation = appModel.dbPath
														
			//Create DB connection
			appModel.txtStatus = "Opening database..."
			db.addEventListener("open", onDBConnectionOpened)
			db.addEventListener("error", onDBConnectionError)
			db.openDB()
				
			
        }          
      
		private function onDBConnectionOpened(event:Event):void
		{			
			Logger.debug("onDBConnectionOpened()", this)			
			
			// MIGRATIONS
			// ...............
			// Now that DB has opened properly...			
			// check for database version and do migrations if necessary			
						
			var migrationMgr:MigrationManager = new MigrationManager()
			appModel.txtStatus = "Checking database version..."
			if (migrationMgr.isDBCurrent==false)
			{
				appModel.txtStatus = "Updating database..."
				migrationMgr.migrateDB()
			}
			else
			{
				Logger.debug("No DB migrations needed.", this)
			}
			
			initLibrary()
								
			//tell everybody initial data is loaded
			Logger.debug("load initial data complete.", this)
			Swiz.dispatch(DatabaseEvent.DATABASE_LOADED)
						
        	//now launch events to init other parts of app
        	var initMenuEvt:DynamicEvent = new DynamicEvent(ApplicationEvent.INIT_MENU)
        	initMenuEvt.mainWindow = _stage    	
        	Swiz.dispatchEvent(initMenuEvt)
        	
        	appModel.viewing = ApplicationModel.VIEW_STARTUP
		}
		
		private function onDBConnectionError(event:Event):void
		{
			//TODO: Make this error nice and more informative
			Alert.show("Could not open connection to database at location: " + db.dbLocation + ". Please check log for details.")
			Logger.error("#LoadInitialDataCommand: sql connection error. event: " + event)
			Swiz.dispatch(DatabaseEvent.DATABASE_LOAD_ERROR)
		}
        */
		
	
		
        
        
        
	}
  
}
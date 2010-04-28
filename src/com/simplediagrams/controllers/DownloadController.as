package com.simplediagrams.controllers
{
	
	import com.simplediagrams.business.SimpleDiagramsDelegate;
	import com.simplediagrams.events.DownloadLibraryEvent;
	import com.simplediagrams.events.SimpleDiagramsLoginEvent;
	import com.simplediagrams.model.DownloadManager;
	import com.simplediagrams.model.LibraryManager;
	import com.simplediagrams.model.RegistrationManager;
	import com.simplediagrams.model.UserModel;
	import com.simplediagrams.model.libraries.DownloadableLibraryVO;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.dialogs.DownloadLibrariesDialog;
	import com.simplediagrams.view.dialogs.SimpleDiagramsLoginDialog;
	
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.controller.AbstractController;
		
	public class DownloadController extends AbstractController 
	{
		
		[Autowire(name='downloadManager')]
		public var downloadManager:DownloadManager
		
		[Autowire(name='registrationManager')]
		public var registrationManager:RegistrationManager
		
		[Autowire(name='dialogsController')]
		public var dialogsController:DialogsController
		
		[Autowire(name='libraryManager')]
		public var libraryManager:LibraryManager
		
		[Autowire(name='simpleDiagramsDelegate')]
		public var simpleDiagramsDelegate:SimpleDiagramsDelegate;
		
		[Autowire(bean="userModel")]
		public var userModel:UserModel
		
		private var _loginDialog:SimpleDiagramsLoginDialog
		private var _downloadLibrariesDialog:DownloadLibrariesDialog
		
		
		public function DownloadController()
		{
		}
		
		[Mediate(event='SimpleDiagramsLoginEvent.CLEAR_LOGIN_CREDENTIALS')]
		public function clearLoginCredentials(event:SimpleDiagramsLoginEvent):void
		{
			if (userModel.loggedIn)
			{
				//make sure user is actually logged out of system if they're currently logged in
				logout()
			}
			
			userModel.clearFromEncryptedStore()	
			userModel.username = ""
			userModel.password = ""			
			userModel.loggedIn = false
		}
		
		protected function logout():void
		{
			executeServiceCall(simpleDiagramsDelegate.logout(), logoutResults, logoutFaults)	
		}
		
		protected function logoutResults(re:ResultEvent):void
		{
			Logger.debug("User logged out.",this)	
		}
		
		
		protected function logoutFaults(fe:FaultEvent):void
		{
			Logger.error("User couldn't log out.",this)				
		}
		
		
		[Mediate(event="DownloadLibraryEvent.DOWNLOAD_AVAILABLE_LIBARIES_LIST")]
		public function downloadAvailableLibariesList(event:DownloadLibraryEvent):void
		{			
			Logger.debug("downloading list of available libraries...", this)
			
			if (registrationManager.isLicensed==false)
			{
				Alert.show("Sorry. This feature is only available to Full Version users. Visit simpledigrams.com and upgrade to Full Version today!", "Full Version Only")					
				return
			}
			
			if (!userModel.loggedIn)
			{
				_loginDialog = dialogsController.showGetSimpleDiagramsLoginDialog()				
				_loginDialog.addEventListener(SimpleDiagramsLoginEvent.ATTEMPT_LOGIN, onAttemptLogin)	
				_loginDialog.addEventListener(Event.CANCEL, onLoginInfoCancel)
				
				//if user has saved info, log in with that
				if (userModel.username && userModel.password)
				{
					_loginDialog.currentState = SimpleDiagramsLoginDialog.STATE_LOGGING_IN
					onAttemptLogin(null)
				}
				else
				{					
					_loginDialog.currentState = SimpleDiagramsLoginDialog.STATE_ENTER_CREDENTIALS
				}
			}
			else // user already logged in, so get library list
			{
				getAvailableLibraries()
			}
		}
		
		protected function onAttemptLogin(event:SimpleDiagramsLoginEvent):void
		{
			Logger.debug("attempting login with username: " + userModel.username + " pw: " + userModel.password + " key : " + registrationManager.licenseKey, this)
			executeServiceCall(simpleDiagramsDelegate.login(userModel, registrationManager.licenseKey), loginResults, loginFaults)	
		}
		
		
		protected function loginResults(re:ResultEvent):void
		{			
			var result:Object = re.result
				
			Logger.debug(" login result:" + result.toString(), this)
			
			if (result!="logged in")
			{
				switch (result)
				{
					/*
					case "invalid key":
						userModel.username = ""
						userModel.password = ""
						_loginDialog.currentState = SimpleDiagramsLoginDialog.STATE_LOGIN_ERROR
						break
					*/
					
					case "invalid login":						
						userModel.username = ""
						userModel.password = ""
						_loginDialog.currentState = SimpleDiagramsLoginDialog.STATE_LOGIN_ERROR
						break
				
					default:								
						userModel.username = ""
						userModel.password = ""		
						_loginDialog.currentState = SimpleDiagramsLoginDialog.STATE_LOGIN_ERROR
				}
				return
			}	
			userModel.loggedIn = true
			removeLoginInfoDialog()
			getAvailableLibraries()
		}
		
		//TODO :: Handle this more gracefully
		
		protected function loginFaults(fe:FaultEvent):void
		{
			Logger.debug("couldn't login:" + fe.message, this)
			if (_loginDialog==null)
			{
				_loginDialog = dialogsController.showGetSimpleDiagramsLoginDialog()				
				_loginDialog.addEventListener(SimpleDiagramsLoginEvent.ATTEMPT_LOGIN, onAttemptLogin)	
				_loginDialog.addEventListener(Event.CANCEL, onLoginInfoCancel)
			}
			_loginDialog.currentState = SimpleDiagramsLoginDialog.STATE_LOGIN_ERROR
		}
		
		protected function onLoginInfoCancel(event:Event):void
		{
			removeLoginInfoDialog()
		}
		
		protected function removeLoginInfoDialog():void
		{
			dialogsController.removeDialog(_loginDialog)			
			_loginDialog.removeEventListener(SimpleDiagramsLoginEvent.ATTEMPT_LOGIN, onAttemptLogin)	
			_loginDialog.removeEventListener(Event.CANCEL, onLoginInfoCancel)
			_loginDialog = null
		}
		
		
		protected function getAvailableLibraries():void
		{
			
			_downloadLibrariesDialog = dialogsController.showDownloadLibrariesDialog()		
			_downloadLibrariesDialog.currentState = DownloadLibrariesDialog.STATE_DOWNLOADING_LIBRARY_LIST
			_downloadLibrariesDialog.addEventListener(Event.CANCEL, onDownloadLibrariesCancel)
										
			executeServiceCall(simpleDiagramsDelegate.getLibraryList(),  getLibrariesListResults, getLibrariesListFaultHandler)	
						
		}
		
		protected function getLibrariesListResults(re:ResultEvent):void
		{			
			var resultsXML:XML = re.result as XML;
			Logger.debug(" get library list ok re:" + re, this)
			Logger.debug(" re.result:" + re.result, this)
			
			var downloadableLibrariesAC:ArrayCollection = new ArrayCollection()
			for each (var library:XML in resultsXML.*)
			{
				Logger.debug("library downloadable --  id:" + library.id, this)
				var lib:DownloadableLibraryVO = new DownloadableLibraryVO()
				lib.id = library.id
				lib.name = library.name
				lib.description = library.description
				downloadableLibrariesAC.addItem(lib) 
			}
			downloadManager.downloadableLibrariesAC = downloadableLibrariesAC
			_downloadLibrariesDialog.currentState = DownloadLibrariesDialog.STATE_SELECT_LIBRARIES_TO_DOWNLOAD
						
		}
		
		protected function getLibrariesListFaultHandler(fe:FaultEvent):void
		{
			Logger.debug("couldn't get library list:" + fe.message, this)
			_downloadLibrariesDialog.currentState = DownloadLibrariesDialog.STATE_DOWNLOAD_LIST_ERROR
		}
		
		protected function onDownloadLibrariesCancel(event:Event):void
		{
			removeDownloadLibrariesDialog()
		}
		
		protected function removeDownloadLibrariesDialog():void
		{
			dialogsController.removeDialog(_downloadLibrariesDialog)			
			_downloadLibrariesDialog.removeEventListener(SimpleDiagramsLoginEvent.ATTEMPT_LOGIN, onAttemptLogin)	
			_downloadLibrariesDialog.removeEventListener(Event.CANCEL, onDownloadLibrariesCancel)
			_downloadLibrariesDialog = null
		}
		
		
	}
}
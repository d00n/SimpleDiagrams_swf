package com.simplediagrams.controllers
{
	
	import com.simplediagrams.business.BasecampDelegate;
	import com.simplediagrams.events.BasecampEvent;
	import com.simplediagrams.events.ExportDiagramEvent;
	import com.simplediagrams.model.ApplicationModel;
	import com.simplediagrams.model.BasecampModel;
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.RegistrationManager;
	import com.simplediagrams.model.vo.PersonVO;
	import com.simplediagrams.model.vo.ProjectVO;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.dialogs.BasecampLoginDialog;
	import com.simplediagrams.view.dialogs.ExportDiagramToBasecampDialog;
	import com.simplediagrams.view.dialogs.NotifyListDialog;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.graphics.*;
	import mx.graphics.codec.PNGEncoder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.controller.AbstractController;

	public class BasecampController extends AbstractController 
	{
		
		[Autowire(name='DialogsController')]
		public var dialogsController:DialogsController
		
		[Autowire(name='applicationModel')]
		public var applicationModel:ApplicationModel
		
		[Autowire(name='registrationManager')]
		public var registrationManager:RegistrationManager
		
		[Autowire(name='diagramModel')]
		public var diagramModel:DiagramModel
		
		[Autowire(name='basecampDelegate')]
		public var basecampDelegate:BasecampDelegate;
		
		[Autowire(name='basecampModel')]
		public var basecampModel:BasecampModel;
		
		private var _exportInfoDialog:ExportDiagramToBasecampDialog	
		private var _notifyListDialog:NotifyListDialog
		private var _loginDialog:BasecampLoginDialog		
		private var _imageByteArray:ByteArray	
		private var _messageBody:String
		private var _extendedMessageBody:String
		private var _messageTitle:String
		private var _view:UIComponent
		private var _uploadImageToken:AsyncToken
		
		public function BasecampController()
		{
		}
		
		[Mediate(event='BasecampEvent.CLEAR_LOGIN_CREDENTIALS')]
		public function clearLoginCredentials(event:BasecampEvent):void
		{
			basecampModel.clearFromEncryptedStore()	
			basecampModel.basecampLogin = ""
			basecampModel.basecampPassword = ""
			basecampModel.basecampURL = ""
		}
		
		[Mediate(event='ExportDiagramEvent.EXPORT_TO_BASECAMP')]
		public function exportDiagram(event:ExportDiagramEvent):void
		{
			Logger.debug("exportDiagram()", this)
			
			//make sure user is licensed
			if (registrationManager.isLicensed==false)
			{
				Alert.show("Sorry. This feature is only available to Full Version users. Visit simpledigrams.com and upgrade to Full Version today!", "Full Version Only")
				return
			}
				
			_view = event.view 
			
			//get login information if not already present
			
			if (basecampModel.basecampLogin=="")
			{
				_loginDialog = dialogsController.showGetBasecampLoginDialog()				
				_loginDialog.addEventListener(BasecampEvent.GET_PROJECTS, getProjects)	
				_loginDialog.addEventListener(Event.CANCEL, onLoginInfoCancel)
				
			}
			else if (basecampModel.projectsAC.length==0)
			{
				_loginDialog = dialogsController.showGetBasecampLoginDialog()
				_loginDialog.currentState = "loggingIn"				
				getProjects(null)
			}
			else
			{	
				getExportInfoFromUser()
			}
		}
		
				
		protected function onLoginInfoCancel(event:Event):void
		{
			//If user cancels login, then clear out their credentials
			//so that they have to enter them again explicitly (until they get a successful login)
			this.basecampDelegate.cancelServiceCall()
			basecampModel.clearFromEncryptedStore()
			removeLoginInfoDialog()
		}
		
		/* This function tries to get a list of projects based
		on the current credentials stored in the basecampModel*/
		protected function getProjects(event:Event):void
		{
			Logger.debug("getProjects()", this)				
			executeServiceCall(basecampDelegate.getProjects(), getProjectsResults, getProjectsFaultHandler)	
		}
				
		protected function getProjectsResults(re:ResultEvent):void
		{			
			var resultsXML:XML = re.result as XML;		
			
			parseProjectsResults(resultsXML)
			
			if (basecampModel.projectsAC.length==0)
			{
				Alert.show("You do not have any projects created in Basecamp. Please go to your Basecamp account and create a project before exporting a SimpleDiagram.","No Projects Created")
				return
			}
									
			if (_loginDialog)
			{
				removeLoginInfoDialog()
			}
			
			getExportInfoFromUser()
						
		}
		
		protected function parseProjectsResults(resultsXML:XML):void
		{
			basecampModel.projectsAC.removeAll()
			
			for each (var project:XML in resultsXML.*)
			{
				var projectVO:ProjectVO = new ProjectVO()
				projectVO.name = project.name
				projectVO.id = project.id
				basecampModel.projectsAC.addItem(projectVO)
			}
			
			basecampModel.projectsAC.refresh()
		}
		
		//TODO :: Handle this more gracefully
		protected function getProjectsFaultHandler(fe:FaultEvent):void
		{
			Logger.error("getProjectsFaultHandler() couldn't get projects:" + fe.message, this)
			if (_loginDialog==null)
			{
				_loginDialog = dialogsController.showGetBasecampLoginDialog()				
				_loginDialog.addEventListener(BasecampEvent.GET_PROJECTS, getProjects)	
				_loginDialog.addEventListener(Event.CANCEL, onLoginInfoCancel)
			}
			_loginDialog.loginFailed()
			Alert.show("An error occurred when trying to login to your Basecamp account. Please re-enter your credentials.", "Basecamp Login Error")	
		}
		
		public function onRefreshProjects(event:Event):void
		{					
			executeServiceCall(basecampDelegate.getProjects(), refreshProjectsResults, refreshProjectsFaultHandler)	
		}
	
		protected function refreshProjectsResults(re:ResultEvent):void
		{			
			var resultsXML:XML = re.result as XML;			
			parseProjectsResults(resultsXML)		
			_exportInfoDialog.projectsRefreshed()					
		}
		
		protected function refreshProjectsFaultHandler(fe:FaultEvent):void
		{
			Logger.error("refreshProjectsFaultHandler() couldn't get projects:" + fe.message, this)
			Alert.show("Error occurred when trying to refresh projects. Error: " + fe.fault, "Basecamp Request Error")	
			_exportInfoDialog.projectsRefreshed()		
		}	
		
		
		
		protected function removeLoginInfoDialog():void
		{
			dialogsController.removeDialog(_loginDialog)			
			_loginDialog.removeEventListener(BasecampEvent.GET_PROJECTS, getProjects)	
			_loginDialog.removeEventListener(Event.CANCEL, onLoginInfoCancel)
			_loginDialog = null
		}
		
		protected function getExportInfoFromUser():void
		{			
						
			var bd:BitmapData = new BitmapData(diagramModel.width, diagramModel.height)
			bd.draw(_view)
			_imageByteArray = new PNGEncoder().encode(bd)
			_messageBody = ""
			_extendedMessageBody = ""
			_messageTitle = ""
				
			_exportInfoDialog = dialogsController.showExportDiagramToBasecampDialog()		
			_exportInfoDialog.addEventListener("OK", onExportDialogOK)	
			_exportInfoDialog.addEventListener("changeLogin", onExportDialogChangeLogin)
			_exportInfoDialog.addEventListener(BasecampEvent.REFRESH_PROJECTS, onRefreshProjects)	
			_exportInfoDialog.addEventListener(Event.CANCEL, onExportCancel)
			_exportInfoDialog.addEventListener(BasecampEvent.CANCEL_UPLOAD, onCancelUpload)
			_exportInfoDialog.imageData = _imageByteArray
		}
		
		
		
		protected function onCancelUpload(event:BasecampEvent):void
		{			
			basecampDelegate.cancelServiceCall()
			_exportInfoDialog.currentState = "normal"
		}
		
		protected function onExportDialogChangeLogin(event:Event):void
		{	
			basecampModel.basecampURL = ""
			basecampModel.basecampLogin = ""
			basecampModel.basecampPassword = ""
			basecampModel.clearFromEncryptedStore()
			
			clearExportInfoDialog()	
			
			_loginDialog = dialogsController.showGetBasecampLoginDialog()				
			_loginDialog.addEventListener(BasecampEvent.GET_PROJECTS, getProjects)	
			_loginDialog.addEventListener(Event.CANCEL, onLoginInfoCancel)
		}
		
		protected function onExportDialogOK(event:Event):void
		{	
					
			_messageBody = _exportInfoDialog.messageBody
			_extendedMessageBody = _exportInfoDialog.extendedMessageBody
			_messageTitle = _exportInfoDialog.messageTitle
			
			//first we upload image
			_uploadImageToken:
			executeServiceCall(basecampDelegate.uploadImage(_imageByteArray), uploadImageHandler, uploadImageFaultHandler)
			
		}
		
		protected function uploadImageHandler(re:ResultEvent):void
		{	
			//if we get an OK after uploading image, now we can add textual data
			
			var resultXML:XML = re.result as XML;
			Logger.debug(" image uploaded image ok:" + resultXML.toXMLString(), this)
				
			var imageUploadID:String = resultXML.id
			Logger.debug(" upload image id is:" + imageUploadID, this)
			
			//now upload the message, which will use the uploaded image			
			uploadMessage(imageUploadID)
		}
		
		protected function uploadImageFaultHandler(fe:FaultEvent):void
		{
			Logger.debug("couldn't upload image:" + fe.message, this)
			// TODO handle fault
			clearExportInfoDialog()	
		}
		
		
		protected function uploadMessage(imageUploadID:String):void
		{	
			//now that image is uploaded, we send the message and refer to the image by upload ID
			executeServiceCall(basecampDelegate.sendMessage(_messageTitle, _messageBody, _extendedMessageBody, imageUploadID, basecampModel.selectedProjectID), resultHandler, faultHandler)
			
		}
		
		protected function resultHandler(re:ResultEvent):void
		{
			Logger.debug("send message result OK :" + re.message, this)
			Alert.show("Export completed.")
			clearExportInfoDialog()
		}
		
		protected function faultHandler(fe:FaultEvent):void
		{
			Logger.debug("send message failed :" + fe.message, this)
			Alert.show("Export failed. Here is the error from Basecamp: " + fe.message, "Basecamp Error")
			clearExportInfoDialog()
		}

		
		
		protected function onExportCancel(event:Event):void
		{			
			clearExportInfoDialog()
		}
				
		protected function clearExportInfoDialog():void
		{
			dialogsController.removeDialog(_exportInfoDialog)
			_exportInfoDialog.removeEventListener("OK", onExportDialogOK)
			_exportInfoDialog.removeEventListener(BasecampEvent.CANCEL_UPLOAD, onCancelUpload)
			_exportInfoDialog.removeEventListener(BasecampEvent.REFRESH_PROJECTS, onRefreshProjects)	
			_exportInfoDialog.removeEventListener(Event.CANCEL, onExportCancel)
			_exportInfoDialog = null
		}	
		
		
		/* ***************/
		/*  NOTIFY LIST  */
		/* ***************/
		
		
		
		[Mediate(event="BasecampEvent.SHOW_CHANGE_NOTIFY_WINDOW")]
		public function showChangeNotifyListWindow(event:BasecampEvent):void
		{
			Logger.debug("Showing change notify list window",this)
			if (_notifyListDialog)
			{
				dialogsController.removeDialog(_notifyListDialog)
			}
			
			_notifyListDialog = dialogsController.showNotifyListDialog()	
			_notifyListDialog.addEventListener("OK", onCloseNotifyListDialog)
			_notifyListDialog.addEventListener(Event.CANCEL, onCancelNotifyListDialog)
				
			if (basecampModel.peopleAC.length==0)
			{				
				_notifyListDialog.currentState="loading"
				executeServiceCall(basecampDelegate.getPeople(), getPeopleHandler, getPeopleHandlerFaultHandler)
			}
			else
			{				
				_notifyListDialog.currentState="normal"
			}
			
		}
		
		protected function onCloseNotifyListDialog(event:Event):void
		{
			basecampModel.selectedPeopleAC.refresh()
			removeNotifyEventListeners()
			this.dialogsController.removeDialog(_notifyListDialog, false)
		}
		
		protected function onCancelNotifyListDialog(event:Event):void
		{
			removeNotifyEventListeners()
			basecampDelegate.cancelServiceCall()
			this.dialogsController.removeDialog(_notifyListDialog, false)
		}
		
		protected function removeNotifyEventListeners():void
		{
			_notifyListDialog.removeEventListener("OK", onCloseNotifyListDialog)
			_notifyListDialog.removeEventListener(Event.CANCEL, onCancelNotifyListDialog)
			
		}
		
		[Mediate(event="BasecampEvent.REFRESH_PEOPLE")]
		public function refreshPeople(event:BasecampEvent):void
		{
			executeServiceCall(basecampDelegate.getPeople(), getPeopleHandler, getPeopleHandlerFaultHandler)
		}
		
		
		protected function getPeopleHandler(re:ResultEvent):void
		{				
			var resultsXML:XML = re.result as XML;			
			
			var peopleArr:Array = new Array()
			for each (var personXML:XML in resultsXML.*)
			{
				var personVO:PersonVO = new PersonVO()				
				personVO.firstName = personXML["first-name"]
				personVO.lastName = personXML["last-name"]
				personVO.id = personXML.id
				Logger.debug("adding firstname: " + personVO.firstName + " to AC",this)
				peopleArr.push(personVO)
			}
			
			basecampModel.peopleArr = peopleArr
				
			Logger.debug("basecampModel.peopleAC.length: " + basecampModel.peopleAC.length,this)
			if (basecampModel.peopleAC.length==0)
			{
				Alert.show("You do not have any people in Basecamp to notify. Maybe it's time to involve others.","No People Available")
				return
			}
			
			basecampModel.peopleAC.refresh()
			
			_notifyListDialog.currentState = "normal"
			
		}
		
		protected function getPeopleHandlerFaultHandler(fe:FaultEvent):void
		{
			Logger.debug("send message failed :" + fe.message, this)
			Alert.show("Couldn't get a list of people from Basecamp. Here is the error from Basecamp: " + fe.message, "Basecamp Error")
		
		}
		
		
		
		
		
	}
}
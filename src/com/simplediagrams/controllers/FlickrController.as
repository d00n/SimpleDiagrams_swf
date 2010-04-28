package com.simplediagrams.controllers
{
	
	import com.simplediagrams.business.FlickrDelegate;
	import com.simplediagrams.events.ExportDiagramEvent;
	import com.simplediagrams.events.FlickrEvent;
	import com.simplediagrams.model.ApplicationModel;
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.FlickrModel;
	import com.simplediagrams.model.RegistrationManager;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.dialogs.FlickrLoginDialog;
	import com.simplediagrams.view.dialogs.ExportDiagramToFlickrDialog;
	
	import flash.net.FileReference
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.utils.ByteArray;
//	import flash.filesystem.*;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.graphics.*;
	import mx.graphics.codec.PNGEncoder;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	
	import org.swizframework.controller.AbstractController;
	
	public class FlickrController extends AbstractController 
	{
		
		[Autowire(name='DialogsController')]
		public var dialogsController:DialogsController
		
		[Autowire(name='applicationModel')]
		public var applicationModel:ApplicationModel
		
		[Autowire(name='registrationManager')]
		public var registrationManager:RegistrationManager
		
		[Autowire(name='diagramModel')]
		public var diagramModel:DiagramModel
		
		[Autowire(name='flickrDelegate')]
		public var flickrDelegate:FlickrDelegate;
		
		[Autowire(name='flickrModel')]
		public var flickrModel:FlickrModel;
		
		private var _loginDialog:FlickrLoginDialog	
		private var _exportDialog:ExportDiagramToFlickrDialog		
		private var _imageByteArray:ByteArray	
		private var _messageBody:String
		private var _extendedMessageBody:String
		private var _messageTitle:String
		private var _view:UIComponent
		private var _uploadImageToken:AsyncToken
//		private var _tempImageFile:File
		
		public function BasecampController():void
		{			
//			var tempImageFileDir:File = File.userDirectory.resolvePath("SimpleDiagrams/temp")
//			if (tempImageFileDir.exists==false)
//			{
//				tempImageFileDir.createDirectory()
//			}
//			_tempImageFile = File.userDirectory.resolvePath("SimpleDiagrams/temp/temp.png")
//			if (_tempImageFile.exists)
//			{
//				_tempImageFile.deleteFile()
//			}
		}
		
		[Mediate(event='FlickrEvent.CLEAR_LOGIN_CREDENTIALS')]
		public function clearLoginCredentials(event:FlickrEvent):void
		{
			flickrModel.clearFromEncryptedStore()	
			flickrModel.username = ""
		}
		
		[Mediate(event='ExportDiagramEvent.EXPORT_TO_FLICKR')]
		public function exportDiagramToFlickr(event:ExportDiagramEvent):void
		{
			Logger.debug("exportDiagramToFlickr()", this)
			
			//make sure user is licensed
			if (registrationManager.isLicensed==false)
			{
				Alert.show("Sorry. This feature is only available to Full Version users. Visit simpledigrams.com and upgrade to Full Version today!", "Full Version Only")
				return
			}
			
			_view = event.view 
			
			//get login information if not already present
			if (flickrModel.frob=="")
			{			
				//we get a frob before we show the dialog page that allows the user to launch the Flickr authorization webpage					
				executeServiceCall(flickrDelegate.getFrob(), getFrobResultHandler, getFrobFaultHandler)
			}
			else
			{	
				showExportDialog()
			}
		}
		
		
					
		
		protected function getFrobResultHandler(event:ResultEvent):void
		{
			//now that we have the frob, we'll let the user authorize SimpleDiagrams
			Logger.debug("got frob: " + event.result.frob, this)
			flickrModel.frob = event.result.frob
			
			Logger.debug("showing dialog", this)	
			_loginDialog = dialogsController.showGetFlickrLoginDialog()		
			_loginDialog.currentState = FlickrLoginDialog.STATE_GET_FROB					
			_loginDialog.addEventListener(Event.CANCEL, onLoginInfoCancel)				
			_loginDialog.addEventListener(FlickrEvent.SHOW_AUTHORIZE_WEBPAGE, showAuthorizeWebpage)
			_loginDialog.addEventListener(FlickrEvent.AUTHORIZATION_COMPLETE, onAuthorizationComplete)			
			_loginDialog.currentState = FlickrLoginDialog.STATE_SHOW_AUTHORIZE				
				
		}
		
		
		protected function getFrobFaultHandler(event:FaultEvent):void
		{
			Logger.debug("error getting frob: " + event, this)
			Alert.show("SimpleDiagrams couldn't contact Flickr to start the authorization process. Please try again later.","Network Error")
		}
		
		protected function onLoginInfoCancel(event:Event):void
		{
			removeLoginInfoDialog()
		}
		
		protected function removeLoginInfoDialog():void
		{
			dialogsController.removeDialog(_loginDialog)			
			_loginDialog.removeEventListener(FlickrEvent.SHOW_AUTHORIZE_WEBPAGE, showAuthorizeWebpage)
			_loginDialog.removeEventListener(FlickrEvent.AUTHORIZATION_COMPLETE, onAuthorizationComplete)	
			_loginDialog.removeEventListener(Event.CANCEL, onLoginInfoCancel)
			_loginDialog = null
		}
			
		
		protected function showAuthorizeWebpage(event:FlickrEvent):void
		{			
			flickrDelegate.showAuthorizePage()		
		}
				
		
		protected function onAuthorizationComplete(event:Event):void
		{
			//we get a frob before we show the dialog page that allows the user to launch the Flickr authorization webpage					
			executeServiceCall(flickrDelegate.getToken(), getTokenResultHandler, getTokenFaultHandler)			
			removeLoginInfoDialog()
		}
		
		
		protected function getTokenResultHandler(event:ResultEvent):void
		{
			//now that we have the frob, we'll let the user authorize SimpleDiagrams
			Logger.debug("got token: " + event.result.token, this)
			flickrModel.authToken = event.result.token
			flickrModel.username = event.result.user.@username
			showExportDialog()	
		}
		
		protected function getTokenFaultHandler(event:FaultEvent):void
		{
			Logger.debug("error getting token: " + event, this)
			Alert.show("SimpleDiagrams couldn't retrieve a security token from Flickr. Please try the process again later.","Network Error")
		}
		
		
		protected function showExportDialog():void
		{
			_exportDialog = dialogsController.showExportDiagramToFlickrDialog()	
			_exportDialog.addEventListener("exportDiagram", uploadImageToFlickr)
				
			var bd:BitmapData = new BitmapData(diagramModel.width, diagramModel.height)
			bd.draw(_view)
			_imageByteArray = new PNGEncoder().encode(bd)	
			//write image to temporary file
			
			//Coding process stopped here. Want to find way to push binary image straight to Flickr withouth having to save to file and then use
			//some kind of file upload (which won't work due to security measures?)
							
		}
				
		
		protected function uploadImageToFlickr(event:FlickrEvent):void
		{				
			Logger.debug("uploadImageToFlickr()", this)
			//executeServiceCall(flickrDelegate.uploadImage(), uploadImageResultHandler, uploadImageFaultHandler)
		}
		
		protected function uploadImageResultHandler(re:ResultEvent):void
		{
			Logger.debug("send image to flickr result OK :" + re.message, this)
			removeExportDialog()			
		}
		
		protected function uploadImageFaultHandler(fe:FaultEvent):void
		{
			Logger.debug("send image to flickr failed :" + fe.message, this)
			removeExportDialog()		
		}
		
		protected function removeExportDialog():void
		{
			dialogsController.removeDialog(_exportDialog)			
			_exportDialog.removeEventListener("exportDiagram", uploadImageToFlickr)
			_exportDialog = null
		}
		
		
		
	}
}
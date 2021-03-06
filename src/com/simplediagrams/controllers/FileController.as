package com.simplediagrams.controllers
{
	import com.simplediagrams.business.FileManager;
	import com.simplediagrams.events.*;
	import com.simplediagrams.model.ApplicationModel;
	import com.simplediagrams.model.DiagramModel;
	import com.simplediagrams.model.LibraryManager;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.dialogs.NewDiagramDialog;
	import com.simplediagrams.view.dialogs.SaveBeforeActionDialog;
	import com.simplediagrams.vo.RecentFileVO;
	
	import flash.events.Event;
//	import flash.filesystem.File;
	
	import mx.controls.Alert;
	
	import org.swizframework.controller.AbstractController;


	public class FileController extends AbstractController
	{
		[Bindable]
		[Autowire(bean="libraryManager")]
		public var libraryManager:LibraryManager;
				
		[Bindable]
		[Autowire(bean="applicationModel")]
		public var appModel:ApplicationModel;
			
		[Bindable]	
		[Autowire(bean="diagramModel")]
		public var diagramModel:DiagramModel
		
		[Bindable]	
		[Autowire(bean="fileManager")]
		public var fileManager:FileManager
				
		[Bindable]	
		[Autowire(bean="dialogsController")]
		public var dialogsController:DialogsController
		
		private var _saveBeforeActionDialog:SaveBeforeActionDialog
		
		private var _newDiagramDialog:NewDiagramDialog
		
		private var _actionAfterSave:String //remembers what to do after a saveBeforeAction event is processed
		
		public function FileController()
		{
		}
		
		[Mediate(event="LoadDiagramEvent.LOAD_DIAGRAM")]
		public function loadDiagram(event:LoadDiagramEvent):void
		{
//			Logger.debug("loadDiagram() nativePath: " + event.nativePath, this)	
//			
//				
//			if (event.nativePath)
//			{
//				var f:File = new File()
//				f.nativePath = event.nativePath
//				if (f.exists)
//				{		
//					dialogsController.showLoadingFileDialog()	
//					fileManager.loadSimpleDiagramFromFile(event.nativePath)	
//				}
//				else
//				{					
//					Alert.show("This file no longer exists at " + event.nativePath)
//					//remove file from recent list
//					for (var i:uint=0;i<libraryManager.recentDiagramsAC.length; i++)
//					{
//						if (RecentFileVO(libraryManager.recentDiagramsAC.getItemAt(i)).data==event.nativePath)
//						{
//							libraryManager.recentDiagramsAC.removeItemAt(i)							
//						}
//					}
//					libraryManager.recentDiagramsAC.refresh()
//				}
//			}
//			else
//			{			
//				dialogsController.showLoadingFileDialog()	
//				fileManager.loadSimpleDiagramFromFile()	
//			}
//								
		}	
		
		[Mediate(event="LoadDiagramEvent.DIAGRAM_LOADED")]
		public function diagramLoaded(event:LoadDiagramEvent):void
		{
			Logger.debug("diagramLoaded()...",this)
			libraryManager.addRecentFilePath(event.nativePath, event.fileName)	
			//the loading dialog will be removed by the diagramController after the diagram is completely built
		}	
		
		
		
		
		[Mediate(event="LoadDiagramEvent.DIAGRAM_LOAD_CANCELED")]
		public function diagramLoadCancelled(event:LoadDiagramEvent):void
		{
			dialogsController.removeDialog()
		}	
		
		[Mediate(event="LoadDiagramEvent.DIAGRAM_LOAD_ERROR")]
		public function diagramLoadError(event:LoadDiagramEvent):void
		{
			Logger.debug("diagramLoadError()",this)
			Alert.show(event.errorMessage, "Load Error")
			dialogsController.removeDialog()
		}					

		
		[Mediate(event="SaveDiagramEvent.SAVE_DIAGRAM_AS")]
		public function saveDiagramAs(event:SaveDiagramEvent):void
		{
			Logger.debug("saveDiagramAs()",this)
			fileManager.saveSimpleDiagramAs()		
		}
		
		
		[Mediate(event="SaveDiagramEvent.SAVE_DIAGRAM")]
		public function saveDiagram(event:SaveDiagramEvent):void
		{						
			Logger.debug("saveDiagram()",this)
			fileManager.saveSimpleDiagram()
		}
		
		[Mediate(event="SaveDiagramEvent.DIAGRAM_SAVED")]
		public function diagramSaved(event:SaveDiagramEvent):void
		{	
			Logger.debug("diagramSaved()",this)
			libraryManager.addRecentFilePath(event.nativePath, event.fileName)
			if (_actionAfterSave) performActionAfterSave()
		}
						
		protected function onSaveNewDiagram(event:Event):void
		{
			Logger.debug("onSaveNewDiagram()", this)
			fileManager.saveSimpleDiagramAs()
			//TODO : Add to recently loaded list 			libraryManager.loadDiagrams()
			
			dialogsController.removeDialog(_newDiagramDialog)	
			removeSaveNewDiagramListeners()
				
		}
		
		protected function onCancelSaveNewDiagram(event:Event):void
		{
			dialogsController.removeDialog(_newDiagramDialog)			
			removeSaveNewDiagramListeners()	
		}
		
		protected function removeSaveNewDiagramListeners():void
		{
			_newDiagramDialog.removeEventListener(NewDiagramDialog.SAVE, onSaveNewDiagram)
			_newDiagramDialog.removeEventListener(Event.CANCEL, onCancelSaveNewDiagram)	
		}
		
						
			
		[Mediate(event="OpenDiagramEvent.OPEN_DIAGRAM_EVENT")]
		public function openDiagram(event:OpenDiagramEvent):void
		{							
			Logger.debug("openDiagram() isDirty: " + diagramModel.isDirty.toString() , this)
			if (diagramModel.isDirty)
			{
				checkSaveBeforeOpen()
			}
			else
			{
				fileManager.loadSimpleDiagramFromFile()
			}			
		}
				
		
		
		[Mediate(event="CloseDiagramEvent.CLOSE_DIAGRAM")]
		public function closeDiagram(event:CloseDiagramEvent):void
		{			
			
			if (diagramModel.isDirty)
			{
				checkSaveBeforeClose()
			}
			else
			{
				appModel.viewing = ApplicationModel.VIEW_STARTUP
				diagramModel.initDiagramModel()
				fileManager.clear()
			}
		}
		
		
		[Mediate(event="CreateNewDiagramEvent.CREATE_NEW_DIAGRAM")]
		public function createNewDiagram(event:CreateNewDiagramEvent):void
		{				
			Logger.debug("createNewDiagram. diagramModel.isDirty = " + diagramModel.isDirty.toString(),this)
			if(diagramModel.isDirty)
			{
				checkSaveBeforeNew()
			}
			else
			{
				startNew()
				fileManager.clear()
			}
			
			
		}
		
		private function startNew():void
		{
			appModel.viewing = ApplicationModel.VIEW_DIAGRAM
			diagramModel.createNew()		//this will launch an "new diagram created" event
				
		}
			
		
		public function checkSaveBeforeOpen():void
		{
			if (_saveBeforeActionDialog)
			{				
				dialogsController.removeDialog(_saveBeforeActionDialog)
			}
			
			_saveBeforeActionDialog = dialogsController.showSaveBeforeActionDialog()
			_saveBeforeActionDialog.mode = SaveBeforeActionDialog.MODE_SAVE_BEFORE_OPEN
			_saveBeforeActionDialog.addEventListener(SaveBeforeActionDialog.SAVE, onSaveBeforeAction)
			_saveBeforeActionDialog.addEventListener(Event.CANCEL, onCancelSaveBeforeAction)
			_saveBeforeActionDialog.addEventListener(SaveBeforeActionDialog.DONT_SAVE, onDontSaveBeforeAction)		
									
		}
		
		public function checkSaveBeforeClose():void
		{
			if (_saveBeforeActionDialog)
			{				
				dialogsController.removeDialog(_saveBeforeActionDialog)
			}
			
			_saveBeforeActionDialog = dialogsController.showSaveBeforeActionDialog()
			_saveBeforeActionDialog.mode = SaveBeforeActionDialog.MODE_SAVE_BEFORE_CLOSE
			_saveBeforeActionDialog.addEventListener(SaveBeforeActionDialog.SAVE, onSaveBeforeAction)
			_saveBeforeActionDialog.addEventListener(Event.CANCEL, onCancelSaveBeforeAction)
			_saveBeforeActionDialog.addEventListener(SaveBeforeActionDialog.DONT_SAVE, onDontSaveBeforeAction)		
									
		}
		
		public function checkSaveBeforeNew():void
		{
			Logger.debug("checkSaveBeforeNew() " , this)
			if (_saveBeforeActionDialog)
			{				
				dialogsController.removeDialog(_saveBeforeActionDialog)
			}
			
			_saveBeforeActionDialog = dialogsController.showSaveBeforeActionDialog()
			_saveBeforeActionDialog.mode = SaveBeforeActionDialog.MODE_SAVE_BEFORE_NEW
			_saveBeforeActionDialog.addEventListener(SaveBeforeActionDialog.SAVE, onSaveBeforeAction)
			_saveBeforeActionDialog.addEventListener(Event.CANCEL, onCancelSaveBeforeAction)
			_saveBeforeActionDialog.addEventListener(SaveBeforeActionDialog.DONT_SAVE, onDontSaveBeforeAction)
						
		}
		
		public function onSaveBeforeAction(event:Event):void
		{										
			Logger.debug("onSaveBeforeAction() " , this)
			_actionAfterSave = _saveBeforeActionDialog.mode
			try
			{				
				saveDiagram(null)
			}
			catch (err:Error)
			{
				Alert.show("Couldn't save current diagram. Error:" + err,"Save Error")
				Logger.error("onSaveBeforeAction() couldn't save the diagram. Error: " + err, this)
				return
			}			
		
		}
		
		public function performActionAfterSave():void
		{
			Logger.debug("_saveBeforeActionDialog.mode: " + _saveBeforeActionDialog.mode, this)
			switch (_actionAfterSave)		
			{
				case SaveBeforeActionDialog.MODE_SAVE_BEFORE_NEW:
					startNew()
					break
					
				case SaveBeforeActionDialog.MODE_SAVE_BEFORE_CLOSE:					
					appModel.viewing = ApplicationModel.VIEW_STARTUP
					diagramModel.initDiagramModel()
					break
					
				case SaveBeforeActionDialog.MODE_SAVE_BEFORE_OPEN:
					fileManager.loadSimpleDiagramFromFile()
					break
					
				default:				
			}
			_actionAfterSave = null
			fileManager.clear()
			dialogsController.removeDialog(_saveBeforeActionDialog)			
			removeSaveBeforeActionEventListeners()
		}
		
		
		public function onCancelSaveBeforeAction(event:Event):void
		{			
			dialogsController.removeDialog(_saveBeforeActionDialog)
			removeSaveBeforeActionEventListeners()
			//and then let user continue working...
		}	
		
		public function onDontSaveBeforeAction(event:Event):void
		{
			switch (_saveBeforeActionDialog.mode)		
			{
				case SaveBeforeActionDialog.MODE_SAVE_BEFORE_NEW:
					startNew()
					break
					
				case SaveBeforeActionDialog.MODE_SAVE_BEFORE_CLOSE:
					diagramModel.createNew()
					Logger.debug("after save before action is canceled, diamgramMOdel.isDirty : " + diagramModel.isDirty.toString(), this)
					appModel.viewing = ApplicationModel.VIEW_STARTUP
					break
					
				case SaveBeforeActionDialog.MODE_SAVE_BEFORE_OPEN:
					fileManager.loadSimpleDiagramFromFile()
					break
					
				default:				
			}
			
			dialogsController.removeDialog(_saveBeforeActionDialog)			
			removeSaveBeforeActionEventListeners()
		}
		
		private function removeSaveBeforeActionEventListeners():void
		{		
			_saveBeforeActionDialog.removeEventListener(SaveBeforeActionDialog.SAVE, onSaveBeforeAction)
			_saveBeforeActionDialog.removeEventListener(Event.CANCEL, onCancelSaveBeforeAction)
			_saveBeforeActionDialog.removeEventListener(SaveBeforeActionDialog.DONT_SAVE, onDontSaveBeforeAction)		
			_saveBeforeActionDialog = null
		}
		
		
	}
}

package com.simplediagrams.controllers
{
	
	import com.simplediagrams.model.*;
	import com.simplediagrams.util.Logger;
	import com.simplediagrams.view.AboutWindow;
	import com.simplediagrams.view.dialogs.*;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.managers.PopUpManager;
	
	import org.swizframework.controller.AbstractController;

	public class DialogsController extends AbstractController
	{
		
		
		protected var _currDialog:UIComponent
		
		//some dialogs have to be tracked individually, since they appear over other dialogs
		protected var _notifyListDialog:NotifyListDialog
		
		protected var _dialogInfo:Dictionary = new Dictionary()
		
		public function DialogsController()
		{
			_dialogInfo[DownloadLibrariesDialog] = 				{ width:650, height:550 }
			_dialogInfo[SimpleDiagramsLoginDialog] = 			{ width:450, height:280 }
			_dialogInfo[BasecampLoginDialog] = 					{ width:450, height:250 }
			_dialogInfo[FlickrLoginDialog] = 					{ width:450, height:250 }
			_dialogInfo[VerifyQuitDialog] = 					{ width:420, height:130 }
			_dialogInfo[ExportDiagramToBasecampDialog] = 		{ width:650, height:660 }
			_dialogInfo[ExportDiagramToFlickrDialog] =	 		{ width:650, height:550 }
			_dialogInfo[OpenDiagramDialog] = 					{ width:770, height:590 }
			_dialogInfo[ManageLibrariesDialog] = 				{ width:400, height:500 }
			_dialogInfo[NewDiagramDialog] = 					{ width:350, height:100 }
			_dialogInfo[NewDiagramDialog] = 					{ width:350, height:150 }
			_dialogInfo[AboutWindow] = 							{ width:620, height:360 }
			_dialogInfo[PreferencesDialog] = 					{ width:400, height:500 }
			_dialogInfo[LoadingLibraryPluginsDialog] = 			{ width:400, height:180 }
			_dialogInfo[LoadingLibraryPluginProgressDialog] = 	{ width:400, height:180 }
			_dialogInfo[LoadingFileDialog] = 					{ width:400, height:180 }
		
			FlexGlobals.topLevelApplication.addEventListener(Event.RESIZE, onResize)
		}
		
		protected function onResize(event:Event):void
		{
			if (_currDialog)
			{
				PopUpManager.centerPopUp(_currDialog)
			}
		}
		
		protected function showDialog(c:Class):UIComponent
		{
			Logger.debug("showDialog: " + c, this)
			if (_currDialog)
			{
				PopUpManager.removePopUp(_currDialog)
			}
			_currDialog = new c() as UIComponent
			
			if (_dialogInfo[c])
			{
				var info:Object = _dialogInfo[c]
				Logger.debug(" setting dialog to width: " + info.width + " height; "+ info.height)
				_currDialog.width=info.width 
				_currDialog.height=info.height				
			}				
			PopUpManager.addPopUp(_currDialog, FlexGlobals.topLevelApplication as DisplayObject, true)
			PopUpManager.centerPopUp(_currDialog)	
			Logger.debug("_curr dialog is now : " + _currDialog, this)
			return _currDialog 
			
		}
		
		public function showLoadingFileDialog():LoadingFileDialog
		{			
			return showDialog(LoadingFileDialog) as LoadingFileDialog
		}
		
		public function showLoadingLibraryPluginProgressDialog():LoadingLibraryPluginProgressDialog
		{			
			return showDialog(LoadingLibraryPluginProgressDialog) as LoadingLibraryPluginProgressDialog
		}
		
		public function showLoadLibraryPluginsDialog():LoadingLibraryPluginsDialog
		{			
			return showDialog(LoadingLibraryPluginsDialog) as LoadingLibraryPluginsDialog
		}
		
		public function showAboutDialog():AboutWindow
		{
			return showDialog(AboutWindow) as AboutWindow
		}
		
		public function showPreferencesDialog():PreferencesDialog
		{
			return showDialog(PreferencesDialog) as PreferencesDialog		
		}	
		
		public function showDownloadLibrariesDialog():DownloadLibrariesDialog
		{
			return showDialog(DownloadLibrariesDialog) as DownloadLibrariesDialog		
		}		
		
		public function showGetSimpleDiagramsLoginDialog():SimpleDiagramsLoginDialog
		{
			return showDialog(SimpleDiagramsLoginDialog) as SimpleDiagramsLoginDialog		
		}
		
		public function showGetBasecampLoginDialog():BasecampLoginDialog
		{
			return showDialog(BasecampLoginDialog) as BasecampLoginDialog
		}
		
		public function showGetFlickrLoginDialog():FlickrLoginDialog
		{
			return showDialog(FlickrLoginDialog) as FlickrLoginDialog
		}
		
		public function showVerifyQuitDialog():VerifyQuitDialog
		{
			return showDialog(VerifyQuitDialog) as VerifyQuitDialog
		}
				
		public function showExportDiagramToBasecampDialog():ExportDiagramToBasecampDialog
		{			
			return showDialog(ExportDiagramToBasecampDialog) as ExportDiagramToBasecampDialog
		}	
		
		public function showExportDiagramToFlickrDialog():ExportDiagramToFlickrDialog
		{			
			return showDialog(ExportDiagramToFlickrDialog) as ExportDiagramToFlickrDialog
		}
		
		public function showOpenDiagramDialog():OpenDiagramDialog
		{			
			return showDialog(OpenDiagramDialog) as OpenDiagramDialog			
		}
				
		public function showManageLibrariesDialog():ManageLibrariesDialog
		{			
			return showDialog(ManageLibrariesDialog) as ManageLibrariesDialog			
		}
				
		public function showCreateDiagramDialog():NewDiagramDialog
		{			
			return showDialog(NewDiagramDialog) as NewDiagramDialog
		}
				
		public function showSaveBeforeActionDialog():SaveBeforeActionDialog
		{
			return showDialog(SaveBeforeActionDialog) as SaveBeforeActionDialog			
		}
		
		public function showExportDiagramDialog():ExportDiagramDialog
		{
			return showDialog(ExportDiagramDialog) as ExportDiagramDialog
		}
		
		public function showDiagramPropertiesDialog():DiagramPropertiesDialog
		{
			return showDialog(DiagramPropertiesDialog) as DiagramPropertiesDialog	
		}
		
		public function showNotifyListDialog():NotifyListDialog
		{
			//this popup appears over the export dialog, so don't use the normal functions (which clears out existing dialog)
			_notifyListDialog = new NotifyListDialog()
			_notifyListDialog.width = 350
			_notifyListDialog.height= 400
			PopUpManager.addPopUp(_notifyListDialog, FlexGlobals.topLevelApplication as DisplayObject, true)
			PopUpManager.centerPopUp(_notifyListDialog)	
			return _notifyListDialog 			
		}
		
				
		
		public function removeDialog(dialog:UIComponent=null, clearCurrent:Boolean = true):void
		{
			if (dialog)
			{
				PopUpManager.removePopUp(dialog)
			}
			else
			{
				Logger.debug("removing dialog: " + _currDialog,this)
				PopUpManager.removePopUp(_currDialog)
			}
			
			if (clearCurrent)
			{				
				_currDialog = null
			}	
		}
	
		
		
	}
}